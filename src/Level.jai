Level :: struct {
    foreground: Texture2D;
    background: Texture2D;
    image: Image;
}

render :: (level: Level) {
    DrawTexture(level.background, 0, 0, WHITE);
    DrawTexture(level.foreground, 0, 0, WHITE);
}
