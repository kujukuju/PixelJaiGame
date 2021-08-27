#import "raylib";
#import "Math";

AnimatedSprite :: struct {
    texture: Texture2D;
    width: int;
    height: int;
    columns: int;
    frameCount: int;
    anchor: Vector2;
    scale: Vector2;
}

CreateAnimatedSprite :: (texture: Texture2D, width: int, height: int, columns: int, frameCount: int, anchor: Vector2 = .{0, 0}, scale: Vector2 = .{1, 1}) -> AnimatedSprite {
    sprite: AnimatedSprite = ---;
    sprite.texture = texture;
    sprite.width = width;
    sprite.height = height;
    sprite.columns = columns;
    sprite.frameCount = frameCount;
    sprite.anchor = anchor;
    sprite.scale = scale;

    return sprite;
}

DrawSprite :: (sprite: AnimatedSprite, position: Vector2, frame: int, tint: Color) {
    scaleSignX := ifx sprite.scale.x < 0 then -1 else 1;
    scaleSignY := ifx sprite.scale.y < 0 then -1 else 1;

    offsetWidth := ifx sprite.scale.x < 0 then sprite.width else 0;
    offsetHeight := ifx sprite.scale.y < 0 then sprite.height else 0;

    rect: Rectangle = ---;
    rect.x = cast(float) (frame % sprite.columns) * sprite.width + offsetWidth;
    rect.y = cast(float) (frame / sprite.columns) * sprite.height + offsetHeight;
    rect.width = cast(float) sprite.width * scaleSignX;
    rect.height = cast(float) sprite.height * scaleSignY;

    // for some reason negative width doesnt work in the destination, only the source
    dest: Rectangle = ---;
    dest.x = position.x - sprite.anchor.x * sprite.width * abs(sprite.scale.x);
    dest.y = position.y - sprite.anchor.y * sprite.height * abs(sprite.scale.y);
    dest.width = sprite.width * abs(sprite.scale.x);
    dest.height = sprite.height * abs(sprite.scale.y);

    // what does origin do here?
    DrawTexturePro(sprite.texture, rect, dest, .{0, 0}, 0, tint);
}
