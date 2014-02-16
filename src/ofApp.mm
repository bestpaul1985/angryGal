#include "ofApp.h"

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
    bg01.loadImage("image/bg001.jpg");
    
    timer01 = 0;
    timer02 = 0;
    gyChange = 0;
    
    contorlBar.set(0,0, ofGetWidth(), ofGetHeight());
    
    
    target t;
    t.pos.set(0, 100);
    t.vel.set(10, 0);
    t.set();
    Targets.push_back(t);
    
    // listen to any of the events for the game
    ofAddListener(GameEvent::events, this, &ofApp::gameEvent);
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
    if (gy.z < -3 ) {
        if (timer02 == 0) {
            bullet b;
            b.pos.set(ofGetWidth()/4+posOffset, ofGetHeight()-80);
            b.vel.set(3+velOffset,-10);
            b.set();
            Bullets.push_back(b);
            bReloadBuller01 = true;
        }
    }else if(gy.z > 3){
        if (timer02 == 0) {
            bullet b;
            b.pos.set(ofGetWidth()/4*3+posOffset, ofGetHeight()-80);
            b.vel.set(-3+velOffset,-10);
            b.set();
            Bullets.push_back(b);
            bReloadBuller01 = true;
        }
    }
    
    for (int i=0; i<Bullets.size(); i++) {
        Bullets[i].update();
    }
    
    //check if we want to remove the bullet
    ofRemove(Bullets, shouldRemoveBullet);
   
    //reloading timer running for keepping bullet amount;
    if(bReloadBuller01){
        timer02++;
        if (timer02 > 10) {
            timer02 = 0;
            bReloadBuller01 = false;
        }
    }

    
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
            ofVec2f b       = Targets[j].targ.pos;
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
    if (Targets.size() == 0) {
        int num = ofRandom(3);
        for (int i=0; i<num; i++) {
            target t;
            t.pos.set(0, ofRandom(0,200));
            t.vel.set(ofRandom(5,10), 0);
            t.set();
            Targets.push_back(t);
        }
       
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    //background uses zoom up and translate
    ofPushMatrix();
    int Z = 0;
    if (bZoomIn) Z = 0;
    ofTranslate(bg01.getWidth()/2,bg01.getHeight()/2, Z);
    ofSetColor(255);
    bg01.draw(-bg01.getWidth()/2, -bg01.getHeight()/2);
    ofPopMatrix();

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
    ofSetColor(255, 255, 0);
    for (int i=0; i<Bullets.size(); i++) {
        Bullets[i].draw();
    }
    
    
    //two red dot for indicating where is the weapone
    ofSetColor(255, 0, 0);
    ofCircle(ofGetWidth()/4*3+posOffset, ofGetHeight()-80, 10);
    ofCircle(ofGetWidth()/4 + posOffset, ofGetHeight()-80, 10);

    
    //tagets will show up when they get out from the room
    for (int i=0; i<Targets.size(); i++) {
        Targets[i].draw();
    }
    
    //the diagram showing up the change about paw force
    int diff=0;
    if (timer01>ofGetWidth()) {
        diff = timer01 - ofGetWidth();
    }
    
    for (int i=0; i<recordPoint.size(); i++) {
        int w =1;
        int h =1;
        
        if (recordPoint[i].z == 1) {
            ofSetColor(255,0,0);
            w = 1;
            h = 1;
        }else{
            ofSetColor(255);
        }
//        ofRect(recordPoint[i].x - diff, recordPoint[i].y, w, h);
    }

}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
  
    if (touch.id == 0) {
        ofPoint touchPos(touch.x,touch.y);
        if (contorlBar.inside(touchPos)) {
//            bulletVel.x = ofMap(touchPos.x, 0,  ofGetWidth()/2, -7, -3,true);
//            bulletOrgPos.x = ofMap(touchPos.x, 0, ofGetWidth(), ofGetWidth()/4 * 3-30, ofGetWidth()/4 * 3+30);
            
            velOffset = ofMap(touchPos.x, 0, ofGetWidth(), -3, 3);
            posOffset = ofMap(touchPos.x, 0, ofGetWidth(), -30, 30);
        }
        
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
   
    if (touch.id == 0) {
        ofPoint touchPos(touch.x,touch.y);
        if (contorlBar.inside(touchPos)) {
            velOffset = ofMap(touchPos.x, 0, ofGetWidth(), -3, 3);
            posOffset = ofMap(touchPos.x, 0, ofGetWidth(), -30, 30);
        }
    }
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

    if (touch.id == 0) {
        velOffset = 0;
        posOffset = 0;
    }
    
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
