#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxCoreMotion.h"

#include "GameEvent.h"
#include "particle.h"
#include "bullet.h"
#include "target.h"
#include "gal.h"

class ofApp : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);
    
    
        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
        static bool shouldRemoveBullet(bullet &b);
        static bool shouldRemoveBug(target &b);
    
        static float map(float value, float inMin, float inMax, float outMin, float outMax, float shaper);
    
        void gameEvent(GameEvent &e);
    
    
    
        ofxCoreMotion   coreMotion;
    
        gal             Gal;

        vector<bullet>  Bullets;
        vector<target>  Targets;
        vector<ofPoint> recordPoint;

        bool            bShowINFO;
        bool            bZoomIn;
        bool            bReloadBuller01;
    
        ofColor         color01;
    
        ofImage         bg01;
        
        float           lastYaw;
        float           gyChange;
        float           posOffset;
        float           attOffset;
        int             timer01;
        int             timer02;
    
        ofPoint lastGY;
        ofPoint bulletVel;
        ofPoint bulletOrgPos;
    
        ofRectangle contorlBar;
    
    
    
    
};


