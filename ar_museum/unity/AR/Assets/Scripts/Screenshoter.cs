using FlutterUnityIntegration;
using System.Collections;
using System.Collections.Generic;
using Newtonsoft.Json.Linq;
using UnityEngine;

[RequireComponent(typeof(UnityMessageManager))]
public class Screenshoter : MonoBehaviour
{
    // Grab the camera's view when this variable is true.
    private bool grabScreenshot;

    [SerializeField]
    [Tooltip("Assign the camera that is taking the screenshot")]
    private CameraRenderEvent cam;

    private UnityMessageManager unityMessageManager;

    // Start is called before the first frame update
    void Start()
    {
        if (cam == null)
        {
            // Not the most ideal search, Cameras should be tagged for search, or referenced.
            cam = GameObject.FindObjectOfType<CameraRenderEvent>();
        }
    }

    private void Awake()
    {
        unityMessageManager = GetComponent<UnityMessageManager>();
    }

    public class ScreenshotMessage
    {
        public string timestamp { get; set; }
        public string name { get; set; }
        public string data { get; set; }
    }

    public void TakeScreenshot(string msg)
    {
        UnityEngine.Debug.Log($"Received flutter message: {msg}");
        StartCoroutine(TakeScreenshotImpl());
    }

    private IEnumerator TakeScreenshotImpl() 
    {
        yield return new WaitForEndOfFrame();

        int width = Screen.width;
        int height = Screen.height;
        var screenshot = new Texture2D(width, height, TextureFormat.ARGB32, false);
        var rect = new Rect(0, 0, width, height);
        screenshot.ReadPixels(rect, 0, 0);
        screenshot.Apply();

        var timestamp = System.DateTime.Now.ToString();
        var screenshotData = screenshot.EncodeToPNG();
        // ScreenCapture.CaptureScreenshot("ARMuseun_" + timestamp + "_Screenshot.png");
        // System.IO.File.WriteAllBytes(Application.dataPath + "ARMuseum_" + timestamp + "_Screenshot.png", screenshotData);

        string name = string.Format("ARMuseum_{0}_Screenshot.png", timestamp);
        Debug.Log("Permission result: " + NativeGallery.SaveImageToGallery(screenshotData, Application.productName + " Captures", name));

        var message = new ScreenshotMessage
        {
            timestamp = timestamp,
            name = "screenshot",
            data = "done"
            // System.Convert.ToBase64String(screenShot.EncodeToPNG())
        };
        unityMessageManager.SendMessageToFlutter(Newtonsoft.Json.JsonConvert.SerializeObject(message));
    }
}