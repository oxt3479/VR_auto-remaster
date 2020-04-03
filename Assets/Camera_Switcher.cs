using UnityEngine;

public class Camera_Switcher : MonoBehaviour {
    public Camera main;
    public Camera left;
    public Camera right;

    public void ShowMainView() {
        left.enabled = false;
        right.enabled = false;
        main.enabled = true;
    }
    
    public void ShowLeftView() {
        left.enabled = true;
        right.enabled = false;
        main.enabled = false;
    }

    public void ShowRightView() {
        left.enabled = false;
        right.enabled = true;
        main.enabled = false;
    }
}
