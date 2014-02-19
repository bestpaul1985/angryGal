#include "ofApp.h"

float ofApp::map(float value, float inMin, float inMax, float outMin, float outMax, float shaper){
    float pct = ofMap (value, inMin, inMax, 0, 1, true);
    pct = powf(pct, shaper);
    float out = ofMap(pct, 0,1, outMin, outMax, true);
    return out;
}

//--------------------------------------------------------------
bool ofApp::shouldRemoveBullet(bullet &b) {
    return b.bRemove;
}

//--------------------------------------------------------------
bool ofApp::shouldRemoveBug(target &b) {
    return b.bRemove;
}

//--------------------------------------------------------------
void ofApp::setup(){	

    ofSetFrameRate(60);
    ofBackground(255, 255, 0);
    ofEnableAlphaBlending();
    
    bool enableAttitude = true; // roll,pitch,yaw
    bool enableAccelerometer = true;
    bool enableGyro = true;
    bool enableMagnetometer = true;
    coreMotion.setup(enableAttitude,enableAccelerometer,enableGyro,enableMagnetometer);
    
    //main
    bShowINFO = false;
    bZoomIn = false;
    bReloadBuller01 = false;

    color01.set(255, 0, 30);
    
    
    timer01 = 0;
    timer02 = 0;
    gyChange = 0;
    
    contorlBar.set(0,0, ofGetWidth(), ofGetHeight());
    
    //setup emeneys
    target t;
    t.set();
    Targets.push_back(t);
    
    // listen to any of the events for the game
    ofAddListener(GameEvent::events, this, &ofApp::gameEvent);
    
    //Gal
    Gal.set();
    imageloader();
    
    //bullet
    bulletOrgPos.set(0, 0);
    attOffsetX = 0;
    attOffsetY = 0;
}

//--------------------------------------------------------------
void ofApp::gameEvent(GameEvent &e) {
    
    cout << "Game Event: "+e.message << endl;
    e.Target->bRemove = true;
    e.Bullet->bRemove = true;
    
}

//--------------------------------------------------------------
void ofApp::update(){
    
    //this timer is for paw diagram
    timer01++;
    ofPoint temp;
    
    coreMotion.update();
   
    ofPoint gy(coreMotion.getGyroscopeData());
    
    //set daigram's position and color
    if (bZoomIn) {
        temp.set(timer01, ofGetHeight()/2 + gy.z*10, 1);
    }else{
        temp.set(timer01, ofGetHeight()/2 + gy.z*10, 0);
    }

    recordPoint.push_back(temp);
    if (recordPoint.size()>480) {
        recordPoint.erase(recordPoint.begin());
    }
    
    
    //bullet setup + bullet reload delay
    
    if (gy.z < -1 ) {
        
        if (!Gal.bLeftHand && !Gal.bRightHand) {
            Gal.bLeftHand = true;
            Gal.bShot = true;
            Gal.lastTime =ofGetElapsedTimeMillis();
            
            bulletOrgPos.set(ofGetWidth()/4+posOffset, ofGetHeight()-80);
            attOffsetY = map(gy.z, 0, -15, 0, 240, 0.5);
        }
        
        
    }else if(gy.z > 1){
        if (!Gal.bLeftHand && !Gal.bRightHand) {
            Gal.bRightHand = true;
            Gal.bShot = true;
            Gal.lastTime =ofGetElapsedTimeMillis();
            
            bulletOrgPos.set(ofGetWidth()/4*3+posOffset, ofGetHeight()-80);
            attOffsetY = map(gy.z, 0, 15, 0, 240, 0.5);

        }
    }
    
    //right hand bullet, check if gal's hand in the middle of the action, if it is , shot a bullet.
    if (Gal.bShot) {
        if (Gal.leftNum == 2 || Gal.rightNum == 2 ) {
            bullet b;
            b.pos.set(bulletOrgPos);
//            int chance = ofRandom(99);
//            if (chance >= 50) {
//                attOffsetX *= -1;
//            }
            b.attraPos.x += attOffsetX;
            b.attraPos.y -= attOffsetY;
            b.attractScale = 1;
            for (int i=0; i<8; i++) {
                b.kknife[i] = &kknife[i];
            }
            b.set();
            Bullets.push_back(b);
            Gal.bShot = false;
        }
    }
    
    
    
    for (int i=0; i<Bullets.size(); i++) {
        Bullets[i].update();
    }
    
    //check if we want to remove the bullet
    ofRemove(Bullets, shouldRemoveBullet);
   
    
    //targets update
    for (int i=0; i<Targets.size(); i++) {
        Targets[i].update();
    }
    
    // check if we should remove any bugs
    ofRemove(Targets, shouldRemoveBug);
    
    
    //did we hit the targets loop we are checking to see if a bullet his a target.
    //if so we are going to launch an event for the game
    for (int i=0; i<Bullets.size(); i++) {
        for (int j=0; j<Targets.size(); j++) {
            ofVec2f a       = Bullets[i].myBullet.pos;
            ofVec2f b       = Targets[j].pos;
            float   minSize = Targets[j].size;
            
            if(a.distance(b) < minSize) {

                static GameEvent newEvent;
                newEvent.message = "TARGET HIT";
                newEvent.Target  = &Targets[j];
                newEvent.Bullet  = &Bullets[i];
                
                ofNotifyEvent(GameEvent::events, newEvent);
                
            }
        }
    }
    
    //check if there is no more target, if it is 0, we will add one.
    
    if (Targets.size()==0) {
        target t;
        t.set();
        Targets.push_back(t);
    }
  
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    //background
    ofSetColor(255);
    bg01.draw(0,0);


    //some info about coreMotion
    if (bShowINFO) {
        // attitude- quaternion
        ofDrawBitmapStringHighlight("Attitude: (quaternion x,y,z,w)", 20, 25);
        ofSetColor(0);
        ofQuaternion quat = coreMotion.getQuaternion();
        ofDrawBitmapString(ofToString(quat.x(),3), 20, 50);
        ofDrawBitmapString(ofToString(quat.y(),3), 90, 50);
        ofDrawBitmapString(ofToString(quat.z(),3), 160, 50);
        ofDrawBitmapString(ofToString(quat.w(),3), 230, 50);
        
        // attitude- roll,pitch,yaw
        ofDrawBitmapStringHighlight("Attitude: (roll,pitch,yaw)", 20, 75);
        ofSetColor(0);
        ofDrawBitmapString(ofToString(coreMotion.getRoll(),3), 20, 100);
        ofDrawBitmapString(ofToString(coreMotion.getPitch(),3), 120, 100);
        ofDrawBitmapString(ofToString(coreMotion.getYaw(),3), 220, 100);
    }
    
 
    
    //bullets. they are particles everything use paw iphone it adds one.
    for (int i=0; i<Bullets.size(); i++) {
        Bullets[i].draw();
    }
    
    //gal back
    Gal.draw();
    
    //two red dot for indicating where is the weapone
//    ofSetColor(255, 0, 0);
//    ofCircle(ofGetWidth()/4*3+posOffset, ofGetHeight()-80, 10);
//    ofCircle(ofGetWidth()/4 + posOffset, ofGetHeight()-80, 10);

    //add atraction force center
//    ofCircle(150+attOffsetX, 150+attOffsetY,10);
    
    //tagets will show up when they get out from the room
    for (int i=0; i<Targets.size(); i++) {
        Targets[i].draw();
    }
    
    //the diagram showing up the change about paw force
//    int diff=0;
//    if (timer01>ofGetWidth()) {
//        diff = timer01 - ofGetWidth();
//    }
//    
//    for (int i=0; i<recordPoint.size(); i++) {
//        int w =1;
//        int h =1;
//        
//        if (recordPoint[i].z == 1) {
//            ofSetColor(255,0,0);
//            w = 1;
//            h = 1;
//        }else{
//            ofSetColor(255);
//        }
////        ofRect(recordPoint[i].x - diff, recordPoint[i].y, w, h);
//    }

}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
  
    if (touch.id == 0) {
        ofPoint touchPos(touch.x,touch.y);
        if (contorlBar.inside(touchPos)) {
            
            int diff =  touchPos.x - ofGetWidth()/2;
            if (diff>0) {
                posOffset = map(diff, 0, ofGetWidth()/2, 0, 80, 0.7);
                attOffsetX = map(diff, 0, ofGetWidth()/2, 0, 80, 0.7);
                Gal.offSet = posOffset;
            }else if(diff<0){
                posOffset = map(diff, 0, -ofGetWidth()/2, 0, -80, 0.7);
                attOffsetX = map(diff, 0, -ofGetWidth()/2, 0, -80, 0.7);
                Gal.offSet = posOffset;
            }else{
                posOffset = 0;
                attOffsetX =0;
                Gal.offSet = posOffset;
            }
        }
    }
    
    cout<<touch<<endl;
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
   
    if (touch.id == 0) {
        ofPoint touchPos(touch.x,touch.y);
        if (contorlBar.inside(touchPos)) {
            
            int diff =  touchPos.x - ofGetWidth()/2;
            if (diff>0) {
                posOffset = map(diff, 0, ofGetWidth()/2, 0, 80, 0.7);
                attOffsetX = map(diff, 0, ofGetWidth()/2, 0, 80, 0.7);
                Gal.offSet = posOffset;
            }else if(diff<0){
                posOffset = map(diff, 0, -ofGetWidth()/2, 0, -80, 0.7);
                attOffsetX = map(diff, 0, -ofGetWidth()/2, 0, -80, 0.7);
                Gal.offSet = posOffset;
            }
           
        }
    }
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

//    if (touch.id == 0) {
//        posOffset = 0;
//        attOffsetX = 0;
//        Gal.offSet = posOffset;
//    }
    
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
//--------------------------------------------------------------
void ofApp::imageloader(){
    //BG
    bg01.loadImage("image/agBG.png");
    
    //right bullet
    for (int i=0; i<8; i++) {
        kknife[i].loadImage("image/skknife0"+ofToString(1+i)+".png");
    }
    

}

