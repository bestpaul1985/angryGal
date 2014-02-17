#pragma once
#include "ofMain.h"
#include "particle.h"

class bullet{

public:
    
    ofPoint     pos, vel, attraPos;
    particle    myBullet;
    ofPoint     sizeRange;
    bool        bRemove;
    float       size;
    int         flyDis;
    float       attractScale;
    
    bullet(){
        size = 20;
        flyDis = 250;
        attraPos.set(150, 150);
        bRemove = false;
        attractScale = 1.5;
    }
    
    void set(){
        myBullet.setInitialCondition(pos.x, pos.y, vel.x, vel.y);
    }
    
    void update(){
        myBullet.resetForce();
        myBullet.addAttractionForce(attraPos.x, attraPos.y, 480, attractScale);
        myBullet.addDampingForce();
        myBullet.update();
        
        //check the bullet fly distance, if it is
        //further than  the limit, remove this bullet
        float dis = attraPos.distance(myBullet.pos);
        if( dis < 10){
            bRemove = true;
        }
        
        size = ofMap( myBullet.pos.y ,ofGetHeight(), attraPos.y, 20, 2, true);
        
    }
    
    void draw(){
        
        ofSetColor(0,0,0);
        ofCircle(myBullet.pos.x, myBullet.pos.y, size);
    }
    
};

