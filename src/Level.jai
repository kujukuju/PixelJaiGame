Level :: struct {
    foreground: Texture2D;
    background: Texture2D;
    image: Image;
}

render :: (level: Level) {
    DrawTexture(level.background, 0, 0, WHITE);
    DrawTexture(level.foreground, 0, 0, WHITE);
}

get_pixel_view :: (level: Level, aabb: AABB2i) -> PixelView {
    image := level.image;

    width := aabb.upper.x - aabb.lower.x;
    height := aabb.upper.y - aabb.lower.y;

    view: PixelView = ---;
    view.image = image;
    view.x = aabb.lower.x;
    view.y = aabb.lower.y;
    view.width = width;
    view.height = height;

    return view;
}
