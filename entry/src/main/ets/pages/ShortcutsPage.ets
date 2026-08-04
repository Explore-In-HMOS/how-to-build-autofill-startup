import { shortcutManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { ArcButton, ArcButtonOptions, ArcButtonPosition, ArcButtonStyleMode } from '@kit.ArkUI';
import { DOMAIN, TAG } from '../constants/Constants';

@Component
export struct ShortcutsPage {
  pathStack: NavPathStack = new NavPathStack();
  @State isLoading: boolean = true;
  @State hasError: boolean = false;
  @State shortcutId: string = '';
  @State shortcutLabel: string = '';
  @State shortcutVisible: boolean = true;

  aboutToAppear(): void {
    this.loadShortcut();
  }

  private loadShortcut(): void {
    this.isLoading = true;
    this.hasError = false;
    shortcutManager.getAllShortcutInfoForSelf()
      .then((data: shortcutManager.ShortcutInfo[]): void => {
        if (data.length > 0) {
          const info: shortcutManager.ShortcutInfo = data[0];
          this.shortcutId = info.id;
          this.shortcutLabel = info.label ?? info.id;
          this.shortcutVisible = info.visible ?? true;
        }
        this.isLoading = false;
      })
      .catch((err: BusinessError): void => {
        hilog.error(DOMAIN, TAG, 'getAllShortcutInfoForSelf failed: %{public}d %{public}s', err.code, err.message);
        this.hasError = true;
        this.isLoading = false;
      });
  }

  private toggleShortcut(): void {
    if (!this.shortcutId) {
      return;
    }
    const nextVisible: boolean = !this.shortcutVisible;
    shortcutManager.setShortcutVisibleForSelf(this.shortcutId, nextVisible)
      .then((): void => {
        this.loadShortcut();
      })
      .catch((err: BusinessError): void => {
        hilog.error(DOMAIN, TAG, 'setShortcutVisibleForSelf failed: %{public}d %{public}s', err.code, err.message);
        this.hasError = true;
      });
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Text($r('app.string.shortcuts_page_title'))
          .fontSize($r('app.float.title_font_size'))
          .fontColor($r('app.color.text_primary'))
          .fontWeight(FontWeight.Bold)

        if (this.isLoading) {
          Text($r('app.string.status_loading'))
            .fontColor($r('app.color.text_secondary'))
        } else if (this.hasError) {
          Text($r('app.string.status_error'))
            .fontColor($r('app.color.status_error'))
        } else if (!this.shortcutId) {
          Text($r('app.string.shortcuts_empty'))
            .fontColor($r('app.color.text_secondary'))
        } else {
          Column({ space: 6 }) {
            Text(this.shortcutLabel)
              .fontSize($r('app.float.menu_title_font_size'))
              .fontColor($r('app.color.text_primary'))
            Text(this.shortcutVisible ? $r('app.string.shortcut_visible') : $r('app.string.shortcut_hidden'))
              .fontSize($r('app.float.menu_subtitle_font_size'))
              .fontColor(this.shortcutVisible ? $r('app.color.status_success') : $r('app.color.status_neutral'))
          }
          .padding($r('app.float.menu_item_padding'))
          .backgroundColor($r('app.color.card_background'))
          .borderRadius($r('app.float.card_radius'))
          .width('85%')

          ArcButton({
            options: new ArcButtonOptions({
              label: $r('app.string.toggle_button_label'),
              position: ArcButtonPosition.BOTTOM_EDGE,
              styleMode: ArcButtonStyleMode.EMPHASIZED_LIGHT,
              onClick: (): void => {
                this.toggleShortcut();
              }
            })
          })
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
export function ShortcutsPageBuilder() {
  ShortcutsPage()
}
