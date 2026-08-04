import { RouteNames } from '../constants/Constants';
import { StartupStatusPageBuilder } from './StartupStatusPage';
import { ShortcutsPageBuilder } from './ShortcutsPage';

interface MenuItem {
  route: RouteNames;
  title: ResourceStr;
  subtitle: ResourceStr;
}

@Entry
@Component
struct Index {
  pathStack: NavPathStack = new NavPathStack();

  private menuItems: MenuItem[] = [
    {
      route: RouteNames.STARTUP_STATUS,
      title: $r('app.string.menu_startup_title'),
      subtitle: $r('app.string.menu_startup_subtitle')
    },
    {
      route: RouteNames.SHORTCUTS,
      title: $r('app.string.menu_shortcuts_title'),
      subtitle: $r('app.string.menu_shortcuts_subtitle')
    }
  ];

  @Builder
  pageMap(name: string) {
    if (name === RouteNames.STARTUP_STATUS) {
      StartupStatusPageBuilder();
    } else if (name === RouteNames.SHORTCUTS) {
      ShortcutsPageBuilder();
    } else {
      NavDestination() {
        Text($r('app.string.unknown_route'))
          .fontColor($r('app.color.text_primary'))
      }
    }
  }

  build() {
    Navigation(this.pathStack) {
      Column({ space: 8 }) {
        Text($r('app.string.app_name'))
          .fontSize($r('app.float.title_font_size'))
          .fontColor($r('app.color.text_primary'))
          .fontWeight(FontWeight.Bold)
          .margin({ top: $r('app.float.title_top_margin') })

        List({ space: 6 }) {
          ForEach(this.menuItems, (item: MenuItem) => {
            ListItem() {
              Column({ space: 2 }) {
                Text(item.title)
                  .fontSize($r('app.float.menu_title_font_size'))
                  .fontColor($r('app.color.text_primary'))
                  .fontWeight(FontWeight.Medium)
                Text(item.subtitle)
                  .fontSize($r('app.float.menu_subtitle_font_size'))
                  .fontColor($r('app.color.text_secondary'))
              }
              .alignItems(HorizontalAlign.Center)
              .width('100%')
              .padding($r('app.float.menu_item_padding'))
              .backgroundColor($r('app.color.card_background'))
              .borderRadius($r('app.float.card_radius'))
            }
            .onClick(() => {
              this.pathStack.pushPathByName(item.route, null);
            })
          }, (item: MenuItem) => item.route)
        }
        .width('90%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.pageMap)
  }
}