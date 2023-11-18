using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

[RequireComponent(typeof(ARRaycastManager))]
public class AR_PlaceObjectOnTap : MonoBehaviour
{

    public GameObject gameObjectToInstantiate;

    private GameObject parentObject;
    private GameObject spawnedObject;
    private ARRaycastManager arRaycastManager;
    private Vector2 touchPosition;
    private Animation animation;

    static List<ARRaycastHit> hits = new List<ARRaycastHit>();

    private void Awake() 
    {
        parentObject = new GameObject("Empty parent object");
        arRaycastManager = GetComponent<ARRaycastManager>();
    }

    bool TryGetTouchPosition(out Vector2 touchPosition) 
    {
        if (Input.touchCount > 0) 
        {
            touchPosition = Input.GetTouch(0).position;
            return true;
        }

        touchPosition = default;
        return false;
    }

    // Update is called once per frame
    void Update()
    {
        if (!TryGetTouchPosition(out Vector2 touchPosition))
        {
            return;
        }

        if (arRaycastManager.Raycast(touchPosition, hits, TrackableType.Planes))
        {
            var hitPose = hits[0].pose;

            if (spawnedObject == null)
            {
                spawnedObject = Instantiate(gameObjectToInstantiate);
                spawnedObject.transform.parent = parentObject.transform;
                spawnedObject.transform.Rotate(0.0f, 180.0f, 0.0f, Space.Self);
                parentObject.transform.SetPositionAndRotation(hitPose.position, hitPose.rotation);
                animation = spawnedObject.GetComponent<Animation>();
            }
            else 
            {
                spawnedObject.transform.position = hitPose.position;
            }
            if (animation != null && !animation.isPlaying)
            {
                animation.Play();
            }
        }
    }
}
