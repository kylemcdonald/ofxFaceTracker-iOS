#include "ofMain.h"
#include "ofxiOS.h"

#include "ofxCv.h"
#include "ofxFaceTracker.h"

class ofApp : public ofxiOSApp {
public:
    ofVideoGrabber cam;
    ofxFaceTracker tracker;
    bool ready;
    
    void setup() {
        ofBackground(0);
        
        cam.setDeviceID(1); // front camera
        cam.setup(640, 480);
        ready = true;
        
        tracker.setup();
    }
    void update() {
        if(!ready) return;
        
        cam.update();
        if(cam.isFrameNew()) {
            tracker.update(ofxCv::toCv(cam));
        }
    }
    void draw() {
        // OF bug https://github.com/openframeworks/openFrameworks/issues/5464
        if(!ready) return;
        
        ofTranslate(ofGetWidth(), 0);
        ofScale(-1, 1);
        
        float scale = ofGetWidth() / cam.getWidth();
        ofScale(scale, scale);
        cam.draw(0, 0);
        tracker.draw();
    }
};

int main() {
    ofiOSWindowSettings settings;
    settings.enableRetina = true;
    settings.enableDepth = true;
    settings.enableAntiAliasing = true;
    settings.numOfAntiAliasingSamples = 4;
    settings.enableHardwareOrientation = true;
    settings.enableHardwareOrientationAnimation = false;
    settings.glesVersion = OFXIOS_RENDERER_ES1;
    settings.windowMode = OF_FULLSCREEN;
    ofCreateWindow(settings);
    return ofRunApp(new ofApp);
}
