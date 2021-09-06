#import "Basic";
#import "raylib";

PLAYER: Player = ---;
LEVEL: Level = ---;

main :: () {
    screenWidth :: 1600;
    screenHeight :: 900;
    
    InitWindow(screenWidth, screenHeight, "Jai Pixel Game");
    defer CloseWindow();

    SetWindowState(ConfigFlags.FLAG_WINDOW_RESIZABLE);
    
    SetTargetFPS(60);

    LEVEL.background = LoadTexture("assets/background.png");
    LEVEL.foreground = LoadTexture("assets/foreground.png");
    LEVEL.image = GetTextureData(LEVEL.foreground);

    PLAYER.sprite = CreateAnimatedSprite(LoadTexture("assets/girl-sheet.gif"), 79, 48, 8, 135, .{0.5, 1}, .{2, 2});
    PLAYER.position = .{500, 450};
    PLAYER.velocity = .{0, 0};

    while !WindowShouldClose() {
        update();
        render();
    }
}

update :: () {
    update(*PLAYER);
}

render :: () {
    BeginDrawing();
    defer EndDrawing();

    ClearBackground(BLANK);

    render(LEVEL);

    render(PLAYER);
}