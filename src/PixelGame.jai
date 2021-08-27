#import "Basic";
#import "raylib";

main :: () {
    screenWidth :: 1600;
    screenHeight :: 900;

    print("going % %", screenWidth, screenHeight);
    
    InitWindow(screenWidth, screenHeight, "Jai Pixel Game");
    defer CloseWindow();

    SetWindowState(ConfigFlags.FLAG_WINDOW_RESIZABLE);
    
    SetTargetFPS(60);

    background: Texture2D = LoadTexture("assets/background.png");
    foreground: Texture2D = LoadTexture("assets/foreground.png");
    girlSheet: Texture2D = LoadTexture("assets/girl-sheet.gif");
    girlSprite: AnimatedSprite = CreateAnimatedSprite(girlSheet, 79, 48, 8, 135, .{0.5, 1}, .{2, 2});

    frame := 0;

    while !WindowShouldClose() {
        {
            BeginDrawing();
            defer EndDrawing();

            ClearBackground(BLANK);

            DrawTexture(background, 0, 0, WHITE);
            DrawTexture(foreground, 0, 0, WHITE);

            frame = (frame + 1) % girlSprite.frameCount;
            if (frame > girlSprite.frameCount / 2) {
                girlSprite.scale.x = -abs(girlSprite.scale.x);
            } else {
                girlSprite.scale.x = abs(girlSprite.scale.x);
            }
            DrawSprite(girlSprite, .{500, 500}, frame, WHITE);
        }
    }
}