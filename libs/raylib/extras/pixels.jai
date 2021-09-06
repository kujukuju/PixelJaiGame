#import "Basic";

GetPixelColor :: (image: Image, x: int, y: int) -> Color {
    if x < 0 || y < 0 || x >= image.width || y >= image.height {
        return BLANK;
    }

    bytes := GetPixelDataSize(image.width, image.height, image.format) / (image.width * image.height);
    index := y * image.width + x;

    return GetPixelColor(image.data + bytes * index, image.format);
}

SetPixelColor :: (image: Image, color: Color, x: int, y: int) {
    if x < 0 || y < 0 || x >= image.width || y >= image.height {
        return;
    }

    bytes := GetPixelDataSize(image.width, image.height, image.format) / (image.width * image.height);
    index := y * image.width + x;

    SetPixelColor(image.data + bytes * index, color, image.format);
}