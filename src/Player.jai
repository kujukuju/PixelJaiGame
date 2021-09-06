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
    accel.y += 0.1;

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
    anchor_offset := round(xy(width, height) * anchor);

    offset := round(start) - start;
    startp := start + offset - anchor_offset;
    endp := end + offset - anchor_offset;

    offset = endp - round(endp);

    aabb_start: AABB2i = ---;
    aabb_start.lower = roundi(startp);
    aabb_start.upper = aabb_start.lower + xy(width, height);

    aabb_end: AABB2i = ---;
    aabb_end.lower = roundi(endp);
    aabb_end.upper = aabb_end.lower + xy(width, height);

    pos, vel := resolve_physics(aabb_start, aabb_end);
    position := pos + offset + anchor_offset;
    velocity := vel + offset;

    return position, velocity;
}

resolve_physics :: (start: AABB2i, end: AABB2i) -> position: Vector2i, velocity: Vector2i {
    line: Line2i = ---;
    line.p1 = start.lower;
    line.p2 = end.lower;

    pixels: [..] Vector2i = get_pixels(line);
    defer array_free(pixels);

    dimensions := start.upper - start.lower;

    position := start.lower;
    for pixel: pixels {
        aabb: AABB2i = ---;
        aabb.lower = pixel;
        aabb.upper = pixel + dimensions;

        if check_collisions(aabb) {
            break;
        }

        position = pixel;
    }

    velocity := position - start.lower;
    return position, velocity;
}

/*
resolve_physics :: (start: Vector2, end: Vector2, width: int, height: int, anchor: Vector2) -> position: Vector2, velocity: Vector2 {
    top_left_offset := roundi(xy(-width * anchor.x, -height * anchor.y));

    line: Line2i = ---;
    line.p1 = roundi(start) + top_left_offset;
    line.p2 = roundi(end) + top_left_offset;

    start_offset := start - round(start);
    end_offset := end - round(end);

    pixels: [..] Vector2i = get_pixels(line);
    defer array_free(pixels);

    position := start;
    // start at 1 so we dont get divide by 0 later
    for i: 1..pixels.count - 1 {
        pixel := pixels[i];

        aabb: AABB2i = ---;
        aabb.lower = pixel;
        aabb.upper = pixel + xy(width, height);

        if check_collisions(aabb) {
            break;
        }

        progress := cast(float) i / (pixels.count - 1);
        position = pixel - top_left_offset + start_offset + (end_offset - start_offset) * progress;
    }

    velocity := position - start;
    return position, velocity;
}
*/

check_collisions :: (aabb: AABB2i) -> bool {
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