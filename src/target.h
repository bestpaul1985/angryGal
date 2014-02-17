#pragma once
#include "ofMain.h"
#include "particle.h"

class target{
public:
    
    ofPoint             pos,vel;
    bool                bRemove;
    particle            targ;
    float               size;
    
    target(){
        bRemove = false;
        size = 15;
    }
    
    void set(){
        bRemove = false;
        targ.setInitialCondition(pos.x, pos.y, vel.x, vel.y);
    }
    
    void update(){
        
        targ.resetForce();
        targ.addDampingForce();
        targ.update();
        cruise();
    }
    
    void draw(){
    
        ofCircle(targ.pos.x, targ.pos.y, size);
    }
    
    void cruise(){
        if ( fabs(targ.pos.x-pos.x) > 320) {
            targ.vel.set(0,0);
            pos.set(targ.pos.x, targ.pos.y);
            vel *= -1;
            targ.setInitialCondition(pos.x, pos.y, vel.x, vel.y);
        }
    }
    
    
};