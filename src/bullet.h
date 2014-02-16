#pragma once
#include "ofMain.h"
#include "particle.h"

class bullet{

public:
    
    ofPoint     pos, vel;
    particle    myBullet;
    bool        bRemove;
    float       size;
    int         flyDis;
    
    bullet(){
        size = 7;
        flyDis = 230;
        bRemove = false;
    }
    
    void set(){
        myBullet.setInitialCondition(pos.x, pos.y, vel.x, vel.y);
    }
    
    void update(){
        myBullet.resetForce();
        myBullet.addDampingForce();
        myBullet.update();
        //check the bullet fly distance, if it is
        //further than  the limit, remove this bullet
        float dis = pos.distance(myBullet.pos);
        if( dis> flyDis){
            bRemove = true;
        }
        size = ofMap(dis, 0, flyDis, size, 2, true);
        
    }
    
    void draw(){
        
        ofCircle(myBullet.pos.x, myBullet.pos.y, size);
    }
    
  

};

