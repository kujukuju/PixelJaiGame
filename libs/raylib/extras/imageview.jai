ImageView :: struct {
    image: Image;
    x: int;
    y: int;
    width: int;
    height: int;
}

CreateImageView :: (image: Image, x: int, y: int, width: int, height: int) -> ImageView {
    view: ImageView = ---;
    view.image = image;
    view.x = x;
    view.y = y;
    view.width = width;
    view.height = height;

    return view;
}

GetPixel :: (view: ImageView, x: int, y: int) -> Color {
    return GetPixelColor(view.image, view.x + x, view.y + y);
}

SetPixel :: (view: ImageView, color: Color, x: int, y: int) {
    SetPixelColor(view.image, color, view.x + x, view.y + y);
}

UpdateTexture :: (texture: Texture2D, view: ImageView) {
    UpdateTexture(texture, view.image.data);
}
