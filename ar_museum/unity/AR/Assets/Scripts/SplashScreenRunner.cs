using FlutterUnityIntegration;
using System.Collections;
using System.Collections.Generic;
using Newtonsoft.Json.Linq;
using UnityEngine;
using UnityEngine.Rendering;


[RequireComponent(typeof(UnityMessageManager))]
public class SplashScreenRunner : MonoBehaviour
{
    private UnityMessageManager unityMessageManager;

    private void Awake()
    {
        unityMessageManager = GetComponent<UnityMessageManager>();
    }

    public class SplashScreenMessage
    {
        public string timestamp { get; set; }
        public string name { get; set; }
        public string data { get; set; }
    }

    IEnumerator Start()
    {
        Debug.Log("Showing splash screen");
        SplashScreen.Begin();
        while (!SplashScreen.isFinished)
        {
            SplashScreen.Draw();
            yield return null;
        }

        var timestamp = System.DateTime.Now.ToString();

        var message = new SplashScreenMessage
        {
            timestamp = timestamp,
            name = "splash",
            data = "done"
        };

        unityMessageManager.SendMessageToFlutter(Newtonsoft.Json.JsonConvert.SerializeObject(message));
        
        Debug.Log("Finished showing splash screen");
    }
}
