//
//  AHSMtpDevice.m
//  mtp-cli
//
//  Created by sam on 2019/7/15.
//  Copyright © 2019 sam. All rights reserved.
//

#import "AHSMtpDevice.h"

@implementation AHSMtpDevice
+ (nullable NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"mtp_device"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ (%@)", self.brand, self.model, self.serialNo];
}

- (void)dealloc {
    LIBMTP_Release_Device(self.mtp_device);
}


- (uint32_t)createFolder:(NSString *)folderPath {
    NSArray *folders = [folderPath componentsSeparatedByString:@"/"];
    uint32_t folder_id = LIBMTP_FILES_AND_FOLDERS_ROOT;
    for (int i = 0; i < folders.count; i ++) {
        NSString *folder = folders[i];
        if (folder.length == 0) continue;
        folder_id = [self createFolder:folder underParent:folder_id];
        if (folder_id == 0) break;
    }
    return folder_id;
}

- (uint32_t)createFolder:(NSString *)folderName underParent:(uint32_t)parentFolder {
    if (!self.avaliable) return 0;
    LIBMTP_file_t *fileList = LIBMTP_Get_Files_And_Folders(self.mtp_device, self.mtp_device->storage->id, parentFolder);
    for (LIBMTP_file_t *file = fileList; file; file = file->next) {
        if (strcmp(folderName.UTF8String, file->filename) == 0) {
            return file->item_id;
        }
    }
    
    int folderId = LIBMTP_Create_Folder(self.mtp_device, (char *)folderName.UTF8String, parentFolder, self.mtp_device->storage->id);
    if (folderId == 0) {
        return 0;
    }
    return folderId;
}



- (BOOL)sendFile:(NSString *)sourcePath underFolder:(NSString *)folderPath {
    if (!self.avaliable) return false;
    NSString *path = sourcePath;
    NSString *fileName = [path componentsSeparatedByString:@"/"].lastObject;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) return 0;
    uint32_t folder_id = [self createFolder:folderPath];
    if (folder_id == 0) {
        return 0;
    }
    LIBMTP_file_t *fileList = LIBMTP_Get_Files_And_Folders(self.mtp_device, self.mtp_device->storage->id, folder_id);
    for (LIBMTP_file_t *file = fileList; file; file = file->next) {
        if (strcmp(fileName.UTF8String, file->filename) == 0) {
            if (LIBMTP_Delete_Object(self.mtp_device, file->item_id) != 0) {
                return 0;
            }
        }
    }
    
    NSDictionary *fileStat = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    LIBMTP_file_t *genfile = LIBMTP_new_file_t();
    genfile->filesize = [fileStat[NSFileSize] integerValue];
    genfile->filename = strdup((char *)fileName.UTF8String);
    genfile->filetype = LIBMTP_FILETYPE_JPEG;
    genfile->parent_id = folder_id;
    genfile->storage_id = self.mtp_device->storage->id;
    if (LIBMTP_Send_File_From_File(self.mtp_device, (char *)path.UTF8String, genfile, NULL, NULL) != 0) {
        return 0;
    }
    return 1;
}

+ (NSArray <AHSMtpDevice *> *)devices {
    LIBMTP_Init();
    LIBMTP_Set_Debug(LIBMTP_DEBUG_NONE);
    LIBMTP_raw_device_t *rawDeviceList = NULL;
    int deviceCount = 0;
    LIBMTP_Detect_Raw_Devices(&rawDeviceList, &deviceCount);
    
    NSMutableArray *devices = @[].mutableCopy;
    for (int i = 0; i < deviceCount; i ++) {
        LIBMTP_mtpdevice_t *mtp_device = LIBMTP_Open_Raw_Device_Uncached(rawDeviceList + i);
        AHSMtpDevice *device = [[AHSMtpDevice alloc] init];
        device.brand = [NSString stringWithUTF8String:LIBMTP_Get_Manufacturername(mtp_device)];
        device.model = [NSString stringWithUTF8String:LIBMTP_Get_Modelname(mtp_device)];
        device.serialNo = [NSString stringWithUTF8String:LIBMTP_Get_Serialnumber(mtp_device)];
        device.mtp_device = mtp_device;
        LIBMTP_Get_Storage(device.mtp_device, LIBMTP_STORAGE_SORTBY_NOTSORTED);
        device.avaliable = (device.mtp_device->storage != NULL);
        [devices addObject:device];
    }
    return devices.copy;
}
@end
