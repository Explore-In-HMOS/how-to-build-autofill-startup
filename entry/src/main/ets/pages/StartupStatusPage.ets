import { autoStartupManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { DOMAIN, TAG } from '../constants/Constants';

@Component
export struct StartupStatusPage {
  pathStack: NavPathStack = new NavPathStack();
  @State isLoading: boolean = true;
  @State hasError: boolean = false;
  @State isAutoStartupEnabled: boolean = false;

  aboutToAppear(): void {
    this.fetchStatus();
  }

  private fetchStatus(): void {
    this.isLoading = true;
    this.hasError = false;
    try {
      autoStartupManager.getAutoStartupStatusForSelf()
        .then((isAutoStartup: boolean): void => {
          this.isAutoStartupEnabled = isAutoStartup;
          this.isLoading = false;
        })
        .catch((err: BusinessError): void => {
          hilog.error(DOMAIN, TAG, 'getAutoStartupStatusForSelf failed: %{public}d %{public}s', err.code, err.message);
          this.hasError = true;
          this.isLoading = false;
        });
    } catch (error) {
      const e = error as BusinessError;
      hilog.error(DOMAIN, TAG, 'getAutoStartupStatusForSelf threw: %{public}d %{public}s', e.code, e.message);
      this.hasError = true;
      this.isLoading = false;
    }
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Text($r('app.string.startup_page_title'))
          .fontSize($r('app.float.title_font_size'))
          .fontColor($r('app.color.text_primary'))
          .fontWeight(FontWeight.Bold)

        if (this.isLoading) {
          Text($r('app.string.status_loading'))
            .fontColor($r('app.color.text_secondary'))
        } else if (this.hasError) {
          Text($r('app.string.status_error'))
            .fontColor($r('app.color.status_error'))
        } else {
          Column({ space: 4 }) {
            Text(this.isAutoStartupEnabled ? $r('app.string.status_enabled') : $r('app.string.status_disabled'))
              .fontSize($r('app.float.status_font_size'))
              .fontWeight(FontWeight.Medium)
              .fontColor(this.isAutoStartupEnabled ? $r('app.color.status_success') : $r('app.color.status_neutral'))
          }
          .padding($r('app.float.menu_item_padding'))
          .backgroundColor($r('app.color.card_background'))
          .borderRadius($r('app.float.card_radius'))
        }
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.pathStack = ctx.pathStack;
    })
  }
}

@Builder
export function StartupStatusPageBuilder() {
  StartupStatusPage()
}
