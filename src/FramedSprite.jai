#import "Math";

// idk what to name this
// animated sprite with keyframes

FramedSprite :: struct {
    sprite: AnimatedSprite;
    animations: [..] FramedAnimation; // oh well
    frame: float;
}

create_framed_sprite :: (sprite: AnimatedSprite) -> FramedSprite {
    framed: FramedSprite;
    framed.sprite = sprite;

    return framed;
}

draw_sprite :: (framed: FramedSprite, position: Vector2) {
    // raylib formatting strikes again
    DrawSprite(framed.sprite, position);
}

add_animation :: (framed: FramedSprite, name: string, start: int, end: int) {
    for anim: framed.animations {
        if anim.name == name {
            return;
        }
    }

    animation: FramedAnimation = ---;
    animation.name = name;
    animation.start = start;
    animation.end = end;

    array_add(*framed.animations, animation);
}

goto_animation :: (framed: *FramedSprite, name: string, frame: int) {
    animation, exists := find_animation(<<framed, name);
    if !exists {
        return;
    }

    frame_count := animation.end - animation.start + 1;
    framed.frame = cast(float) (frame % frame_count + animation.start);
    framed.sprite.frame = cast(int) framed.frame;
}

step_animation :: (framed: *FramedSprite, name: string) {
    step_animation(framed, name, 1.0);
}

step_animation :: (framed: *FramedSprite, name: string, frames: float) {
    animation, exists := find_animation(<<framed, name);
    if !exists {
        return;
    }

    frame_count := animation.end - animation.start + 1.0;
    frame := framed.frame - animation.start;
    if frame < 0 || frame >= frame_count {
        frame = 0;
    } else {
        frame += frames;
    }

    // why doesnt floating mod % mod exist?
    framed.frame = fmod(frame, frame_count) + animation.start;
    framed.sprite.frame = cast(int) framed.frame;
}

#scope_file

FramedAnimation :: struct {
    name: string;
    start: int;
    end: int;
}

find_animation :: (framed: FramedSprite, name: string) -> FramedAnimation, bool {
    for anim: framed.animations {
        if anim.name == name {
            return anim, true;
        }
    }

    return .{}, false;
}
