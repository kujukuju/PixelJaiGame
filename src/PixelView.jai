#import "Basic";

// TODO rename to image view
PixelView :: struct {
    image: Image;
    x: int;
    y: int;
    width: int;
    height: int;
}

get_pixel :: (view: PixelView, x: int, y: int) -> Color {
    return GetPixelColor(view.image, view.x + x, view.y + y);
}

set_pixel :: (view: PixelView, color: Color, x: int, y: int) {
    SetPixelColor(view.image, color, view.x + x, view.y + y);
}

update_texture :: (texture: Texture2D, view: PixelView) {
    UpdateTexture(texture, view.image.data);
}
