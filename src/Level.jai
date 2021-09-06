Level :: struct {
    foreground: Texture2D;
    background: Texture2D;
    image: Image;
}

render :: (level: Level) {
    DrawTexture(level.background, 0, 0, WHITE);
    DrawTexture(level.foreground, 0, 0, WHITE);
}

get_pixel_view :: (level: Level, aabb: AABB2) -> PixelView {
    image := level.image;

    lower: [2] int = ---;
    lower[0] = cast(int) aabb.lower.x;
    lower[1] = cast(int) aabb.lower.y;

    upper: [2] int = ---;
    upper[0] = cast(int) aabb.upper.x;
    upper[1] = cast(int) aabb.upper.y;

    width := upper[0] - lower[0];
    height := upper[1] - lower[1];

    view: PixelView = ---;
    view.image = image;
    view.x = lower[0];
    view.y = lower[1];
    view.width = width;
    view.height = height;

    return view;
}
