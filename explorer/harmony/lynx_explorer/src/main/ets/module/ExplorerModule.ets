// Copyright 2023 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

import { LLog, LynxModule } from '@lynx/lynx';
import { LynxRecorderEnv } from '@lynx/lynx_devtool';
import router from '@ohos.router';
import preferences from '@ohos.data.preferences';
import Constants from '../common/constants';

const PREFERENCES_NAME = 'lynx_explorer_storage';

const TAG = 'ExplorerModule'

export class ExplorerModule extends LynxModule {
  public openScan() {
    console.log('ExplorerModule', 'openScan');
    router.pushUrl({
      url: Constants.SCAN_URL,
    }).catch((error: Error) => {
      LLog.d(TAG, 'open scan error, ' + JSON.stringify(error));
    });
  }

  public openSchema(url: string) {
    console.log('ExplorerModule', 'openSchema', url);
    let pageUrl = Constants.LYNX_URL;
    if (url.startsWith(LynxRecorderEnv.RECORDER_URL_PREFIX)) {
      pageUrl = Constants.LYNX_RECORDER_URL
    }
    router.pushUrl({
      url: pageUrl,
      params: {
        url: url,
      }
    }).then(() => {
      LLog.d(TAG, 'openSchema succeed');
    }).catch((error: Error) => {
      LLog.d(TAG, 'openSchema error, ' + JSON.stringify(error));
    });
  }

  public saveToLocalStorage(key: string, value: string): void {
    try {
      const context = getContext(this);
      const pref = preferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
      pref.putSync(key, value);
      pref.flush();
      LLog.d(TAG, 'saveToLocalStorage succeed for key: ' + key);
    } catch (error) {
      LLog.d(TAG, 'saveToLocalStorage error: ' + JSON.stringify(error));
    }
  }

  public readFromLocalStorage(key: string): string | null {
    try {
      const context = getContext(this);
      const pref = preferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
      const value = pref.getSync(key, null);
      LLog.d(TAG, 'readFromLocalStorage succeed for key: ' + key);
      return value as string | null;
    } catch (error) {
      LLog.d(TAG, 'readFromLocalStorage error: ' + JSON.stringify(error));
      return null;
    }
  }
}
