#import "Basic";
#import "raylib";

PLAYER: Player;
LEVEL: Level;
FRAME := 0;

percentage_loop: float64;
finish_time: float64;

main :: () {
    screenWidth :: 1600;
    screenHeight :: 900;
    
    InitWindow(screenWidth, screenHeight, "Jai Pixel Game");
    defer CloseWindow();

    SetWindowState(ConfigFlags.FLAG_WINDOW_RESIZABLE);
    
    SetTargetFPS(60);

    LEVEL.background = LoadTexture("assets/background2.png");
    LEVEL.foreground = LoadTexture("assets/foreground2.png");
    LEVEL.image = GetTextureData(LEVEL.foreground);

    // its really annoying that raylib is CapStart and jai is underscore_lowercase
    // should I fix that?
    // MUCH BETTER
    animated_sprite := CreateAnimatedSprite(LoadTexture("assets/girl-sheet.gif"), 74, 48, 8, 135, .{32.0 / 74.0, 1.0}, .{2, 2});
    PLAYER.sprite = create_framed_sprite(animated_sprite);
    PLAYER.position = .{500, 450};
    PLAYER.velocity = .{0, 0};
    
    add_animation(PLAYER.sprite, "idle", 0, 0);
    add_animation(PLAYER.sprite, "run", 1, 24);
    add_animation(PLAYER.sprite, "jump", 35, 54);

    last_time := get_time();
    while !WindowShouldClose() {
        new_time := get_time();
        percentage_loop = (finish_time - last_time) / (new_time - last_time);
        last_time = new_time;

        update();
        render();

        FRAME += 1;

        reset_temporary_storage();
    }
}

update :: () {
    update_mouse();
    update(*PLAYER);
}

render :: () {
    BeginDrawing();
    defer EndDrawing();

    UpdateTexture(LEVEL.foreground, LEVEL.image.data);
    ClearBackground(BLANK);

    render(LEVEL);

    render(*PLAYER);

    DrawText(tprint("% FPS", GetFPS()), 10, 10, 20, WHITE);
    DrawText(tprint("CPU: %1%%", round(percentage_loop * 10000.0) / 100.0), 10, 40, 20, WHITE);

    finish_time = get_time();
}

update_mouse :: () {
    if IsMouseButtonDown(.MOUSE_LEFT_BUTTON) {
        mouse := roundi(GetMousePosition());
        view := CreateImageView(LEVEL.image, mouse.x - 50, mouse.y - 50, 100, 100);

        for x: -50..50 {
            for y: -50..50 {
                d2 := x * x + y * y;
                if d2 > 50 * 50 {
                    continue;
                }

                SetPixel(view, BLANK, x + 50, y + 50);
            }
        }
    }
    if IsMouseButtonDown(.MOUSE_RIGHT_BUTTON) {
        mouse := roundi(GetMousePosition());
        view := CreateImageView(LEVEL.image, mouse.x - 10, mouse.y - 10, 20, 20);

        for x: -10..10 {
            for y: -10..10 {
                d2 := x * x + y * y;
                if d2 > 10 * 10 {
                    continue;
                }

                SetPixel(view, BLACK, x + 10, y + 10);
            }
        }
    }
}