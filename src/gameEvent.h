#pragma once
#include "ofMain.h"
#include "target.h"
#include "bullet.h"

class GameEvent : public ofEventArgs {
    
public:
    
    bullet      * Bullet;
    target      * Target;
    string      message;
    
    GameEvent() {
        Bullet = NULL;
        Target    = NULL;
    }
    
    static ofEvent <GameEvent> events;
};
