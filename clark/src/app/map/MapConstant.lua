local MapConstant = {};

MapConstant.SIDE_BAR_WIDTH         = 110;

MapConstant.PLAY_DEFAULT_SCALE     = 0.7;
MapConstant.ZOOM_TIME              = 0.1;
MapConstant.FIRE_RANGE_SIZE        = 128;
MapConstant.FIRE_RANGE_SCALE_Y     = 0.8;

MapConstant.FIRE_RANGE_ZORDER      = 150;
MapConstant.DEFAULT_OBJECT_ZORDER  = 100;
MapConstant.MAX_OBJECT_ZORDER      = 20000;
MapConstant.BULLET_ZORDER          = 21000;
MapConstant.NORMAL_TRACKING_SPEED  = 3;
MapConstant.FAST_TRACKING_SPEED    = 12;
MapConstant.SET_FAST_TRACKING_DIST = display.height / 3;

MapConstant.CROSS_POINT_TAP_RADIUS = 50;
MapConstant.HP_BAR_ZORDER          = 30000;
MapConstant.HP_BAR_OFFSET_Y        = 20;
MapConstant.RADIUS_CIRCLE_SCALE_Y  = 0.85;

MapConstant.LEVEL_LABEL_OFFSET_Y   = 26;
MapConstant.LEVEL_LABEL_FONT       = display.DEFAULT_TTF_FONT;
MapConstant.LEVEL_LABEL_FONT_SIZE  = 16;

MapConstant.PLAYER_CAMP            = 1;
MapConstant.ENEMY_CAMP             = 2;

return MapConstant;
