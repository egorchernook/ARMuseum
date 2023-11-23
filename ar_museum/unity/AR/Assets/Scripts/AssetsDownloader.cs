using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class AssetsDownloader : MonoBehaviour
{
    [SerializeField]
    public AssetBundle assetBundle;

    void downloadFrom(string url)
    {
        StartCoroutine(GetAssetBundle(url));
    }

    IEnumerator GetAssetBundle(string url)
    {
        UnityWebRequest unityWebRequest = UnityWebRequestAssetBundle.GetAssetBundle(url);
        yield return unityWebRequest.SendWebRequest();

        if (unityWebRequest.result != UnityWebRequest.Result.Success)
        {
            Debug.Log(unityWebRequest.error);
        }
        else
        {
            assetBundle = DownloadHandlerAssetBundle.GetContent(unityWebRequest);
        }
    }
}
