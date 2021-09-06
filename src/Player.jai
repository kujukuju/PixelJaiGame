#import "raylib";
#import "Math";
#import "JaiMath";

Player :: struct {
    sprite: AnimatedSprite;
    position: Vector2;
    velocity: Vector2;
}

update :: (player: *Player) {
    accel := Vector2.{0, 0};
    if IsKeyDown(.KEY_W) {
        accel.y -= 1;
    }
    if IsKeyDown(.KEY_A) {
        accel.x -= 1;
    }
    if IsKeyDown(.KEY_S) {
        accel.y += 1;
    }
    if IsKeyDown(.KEY_D) {
        accel.x += 1;
    }
    accel = unit_vector(accel);

    // gravity
    accel.y += 0.01;

    player.velocity += accel;

    old_position := player.position;
    new_position := player.position + player.velocity;

    position, velocity := resolve_physics(old_position, new_position, player.sprite.width, player.sprite.height, player.sprite.anchor);
    player.position = position;
    player.velocity = velocity;

    player.sprite.frame = (player.sprite.frame + 1) % player.sprite.frameCount;
}

render :: (player: Player) {
    DrawSprite(PLAYER.sprite, PLAYER.position);
}

resolve_physics :: (start: Vector2, end: Vector2, width: int, height: int, anchor: Vector2) -> position: Vector2, velocity: Vector2 {
    top_left_offset := xy(floor(-width * anchor.x), floor(-height * anchor.y));

    line: Line2 = ---;
    line.p1 = start + top_left_offset;
    line.p2 = end + top_left_offset;

    pixels: [..] [2] int = get_pixels(line);
    defer array_free(pixels);

    position := start;
    for pixel: pixels {
        aabb: AABB2 = ---;
        aabb.lower = xy(cast(float) pixel[0], cast(float) pixel[1]);
        aabb.upper = xy(cast(float) pixel[0] + width, cast(float) pixel[1] + height);

        if check_collisions(aabb) {
            break;
        }

        position = xy(pixel[0] - top_left_offset.x, pixel[1] - top_left_offset.y);
    }

    velocity := position - start;
    return position, velocity;
}

check_collisions :: (aabb: AABB2) -> bool {
    view: PixelView = get_pixel_view(LEVEL, aabb);

    for x: 0..view.width - 1 {
        for y: 0..view.height - 1 {
            if get_pixel(view, x, y).a != 0 {
                set_pixel(view, BLANK, x, y);
            }
        }
    }

    update_texture(LEVEL.foreground, view);

    return false;
}