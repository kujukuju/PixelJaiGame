#import "raylib";
#import "Math";
#import "JaiMath";

Player :: struct {
    sprite: FramedSprite;
    position: Vector2;
    velocity: Vector2;
    jumping: bool;
}

update :: (player: *Player) {
    // inputs
    accel := 0.0;
    if IsKeyDown(.KEY_A) {
        accel -= 4;
    }
    if IsKeyDown(.KEY_D) {
        accel += 4;
    }

    // friction
    if abs(player.velocity.x) < FRICTION {
        player.velocity.x = 0;
    } else {
        player.velocity.x -= FRICTION * sign(player.velocity.x);
    }

    // accel
    if abs(player.velocity.x + accel) <= MAX_SPEED {
        player.velocity.x = player.velocity.x + accel;
    } else if abs(player.velocity.x) <= MAX_SPEED {
        // this implies that this tick we tried to go above the max speed
        player.velocity.x = MAX_SPEED * sign(accel);
    }
    // otherwise were above the max velocity so we don't add acceleration I guess?

    // jumping
    if IsKeyDown(.KEY_W) && !player.jumping {
        player.jumping = true;
        player.velocity.y = -JUMP;
    }

    // gravity
    player.velocity.y += GRAVITY;

    dimensions := xy(player.sprite.sprite.width / 2.0, cast(float) player.sprite.sprite.height);
    position, velocity := resolve_physics(player.position, player.velocity, dimensions, player.sprite.sprite.anchor);
    player.position = position;
    player.velocity = velocity;
}

render :: (player: *Player) {
    if player.velocity.x < 0 {
        player.sprite.sprite.scale.x = abs(player.sprite.sprite.scale.x); // oh no
    } else if player.velocity.x > 0 {
        player.sprite.sprite.scale.x = -abs(player.sprite.sprite.scale.x);
    }
    
    if player.jumping {
        // gonna have to have some version of step_animation that clamps 
        step_animation(*player.sprite, "jump", 0.25);
    } else if player.velocity.x == 0 {
        step_animation(*player.sprite, "idle", 0.5);
    } else {
        step_animation(*player.sprite, "run", 0.5);
    }

    draw_sprite(player.sprite, round(player.position));
}

#scope_file

FRICTION :: 0.5;
ACCEL :: 1.0;
GRAVITY :: 0.5;
JUMP :: 12;
MAX_SPEED :: 4;
