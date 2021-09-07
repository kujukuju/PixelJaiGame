#import "Basic";
#import "Math";
#import "JaiMath";

resolve_physics :: (start: Vector2, velocity: Vector2, dimensions: Vector2, anchor: Vector2) -> position: Vector2, velocity: Vector2 {
    aabb: AABB2 = ---;
    aabb.lower = start - anchor * dimensions;
    aabb.upper = start + (1.0 - anchor) * dimensions;

    final_aabb, velocity := resolve_physics(aabb, velocity);
    final_position := final_aabb.lower + anchor * dimensions;

    return final_position, velocity;
}

// walls are next
// OKAY I think I sit on this for the day and think about how to do walls
// I think this method of floating point physics solves a lot of the issues I would have had with walls
// walls are gonna be like:
// step through the pixels, when you collide with a pixel adjust yourself to be outside that pixel in a way that resolves the
// collision (doesn’t just go backwards) (this is hard, does it move in directions normal to the velocity line only? and if a valid position isnt found it reverses to the previous valid point?)
// when you collide with a pixel, after youve resolved it, adjust your velocity to be normal tangent to the line of pixels
// stop stepping when your next step will go past the length of your velocity for this tick
// this isnt right
// your final position will be a floating point that includes the entireity of your velocity length

// OKAY STREAM OVER
// TOMORROW PROBABLY I DO WALL PHYSICS
// THEN THE NEXT DAY MORE WALL PHYSICS
// THEN THE NEXT DAY SHOOTING GROUND TO BREAK PIXELS AND SHIT SO YOU CAN ACTUALLY TAKE ADVANTAGE OF THE PIXEL ENGINE
// THEN THE NEXT DAY I PROBABLY STOP AND START WORK ON MY NEXT YEAR LONG GAME PROJECT IN JAI
// WOOOOO

resolve_physics :: (start: AABB2, velocity: Vector2) -> position: AABB2, velocity: Vector2 {
    if length(velocity) == 0 {
        return start, velocity;
    }

    // this is not great, yet, because its stepping with lengths less than one entire step into the next pixel, so it will get overlapped pixels
    // like forming and L shape and stuff
    remaining_length := length(velocity);
    step := normalize(velocity);
    position := start;
    new_velocity := velocity;
    while remaining_length > 0 {
        // is this kind of thing too confusing? idk
        new_position: AABB2 = ---;
        if remaining_length >= 1 {
            new_position = position + step;
        } else {
            // partial steps to preserve floating point accuracy
            new_position = position + step * remaining_length;
        }

        pixel_new_position := roundi(new_position);

        if check_collisions(pixel_new_position) {
            step_up_offset := step_up(pixel_new_position);
            if step_up_offset != .{0, 0} {
                // TODO do this less stupidly
                PLAYER.jumping = false;
                new_position = new_position + step_up_offset;
                new_velocity.y = 0;
            } else {
                // actual collision we can't resolve, for now stop here?
                return position, .{0, 0};
            }
        }

        position = new_position;
        // each step is a length of 1 for now
        remaining_length = max(remaining_length - 1.0, 0);
    }

    return position, new_velocity;
}

check_collisions :: (aabb: AABB2i) -> bool {
    view: ImageView = CreateImageView(LEVEL.image, aabb.lower.x, aabb.lower.y, aabb.upper.x - aabb.lower.x, aabb.upper.y - aabb.lower.y);

    // can also be optimized because it moves 1 pixel at a time so we only need to check the perimeter
    for x: 0..view.width - 1 {
        for y: 0..view.height - 1 {
            if GetPixel(view, x, y).a != 0 {
                // SetPixel(view, BLANK, x, y);
                return true;
            }
        }
    }

    return false;
}

// tries to step up from your current position, returns the necessary offset
step_up :: (aabb: AABB2i) -> Vector2i {
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

#scope_file

STEP_HEIGHT :: 16;