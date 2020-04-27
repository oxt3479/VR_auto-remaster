using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EyesParameterProvider : MonoBehaviour {


    protected int parameterHashVector;
    protected int parameterHashFloat;
    public Vector4 leftEye = new Vector4(0.0f,0.0f,1.0f,0.5f);
    public Vector4 rightEye = new Vector4(0.0f,0.5f,1.0f,0.5f);
    protected Camera cam;

    void Awake()
    {
        parameterHashVector = Shader.PropertyToID("_EyeTransformVector");
        parameterHashFloat = Shader.PropertyToID("_EyeFloatFlag");
        cam = GetComponent<Camera>();
    }

    void OnPreRender() 
    {
        Shader.SetGlobalVector(parameterHashVector,cam.stereoActiveEye == Camera.MonoOrStereoscopicEye.Left ? leftEye : rightEye);
        Shader.SetGlobalFloat(parameterHashFloat,cam.stereoActiveEye == Camera.MonoOrStereoscopicEye.Left ? -1.0f : (cam.stereoActiveEye == Camera.MonoOrStereoscopicEye.Right ? 1.0f : 0.0f));
    }

}
