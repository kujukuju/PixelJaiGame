#import "raylib";
#import "Math";
#import "JaiMath";

Player :: struct {
    sprite: AnimatedSprite;
    position: Vector2;
    velocity: Vector2;
    jumping: bool;
}

update :: (player: *Player) {
    player.velocity.x = 0;

    accel := Vector2.{0, 0};
    if IsKeyDown(.KEY_A) {
        accel.x -= 10;
    }
    if IsKeyDown(.KEY_D) {
        accel.x += 10;
    }

    if IsKeyDown(.KEY_W) && !player.jumping {
        player.jumping = true;
        accel.y -= 12;
    }

    // gravity
    accel.y += 0.5;

    player.velocity += accel;

    old_position := player.position;
    new_position := player.position + player.velocity;

    position, velocity := resolve_physics(old_position, new_position, player.sprite.width / 2, player.sprite.height, player.sprite.anchor);
    player.position = position;
    player.velocity = velocity;

    if position.y < new_position.y {
        player.jumping = false;
    }

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

    // make pixels relative
    for *pixel: pixels {
        <<pixel = <<pixel - start.lower;
    }

    dimensions := start.upper - start.lower;

    offset := Vector2i.{0, 0};
    position := start.lower;
    for pixel: pixels {
        aabb: AABB2i = ---;
        aabb.lower = pixel + start.lower + offset;
        aabb.upper = pixel + start.lower + offset + dimensions;

        if check_collisions(aabb) {
            step_offset := step_up(aabb);
            if step_offset == .{0, 0} {
                break;
            }

            offset = offset + step_offset;
            aabb.lower = aabb.lower + step_offset;
            aabb.upper = aabb.upper + step_offset;
        }

        position = aabb.lower;
    }

    velocity := position - start.lower;
    return position, velocity;
}

check_collisions :: (aabb: AABB2i) -> bool {
    view: ImageView = CreateImageView(LEVEL.image, aabb.lower.x, aabb.lower.y, aabb.upper.x - aabb.lower.x, aabb.upper.y - aabb.lower.y);

    for x: 0..view.width - 1 {
        for y: 0..view.height - 1 {
            if GetPixel(view, x, y).a != 0 {
                return true;
                // set_pixel(view, BLANK, x, y);
            }
        }
    }

    // update_texture(LEVEL.foreground, view);

    return false;
}

// tries to step up from your current position, returns the necessary offset
step_up :: (aabb: AABB2i) -> Vector2i {
    STEP_HEIGHT :: 8;

    for y: 0..STEP_HEIGHT {
        new_aabb: AABB2i = ---;
        new_aabb.lower = aabb.lower - xy(0, y);
        new_aabb.upper = aabb.upper - xy(0, y);

        if !check_collisions(new_aabb) {
            return xy(0, -y);
        }
    }

    return Vector2i.{0, 0};
}