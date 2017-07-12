#!/usr/bin/env python
import rospy, json, ipfsapi
from goprohero import GoProHero

urlopen = lambda x: x
try:
    import urllib2
    urlopen = urllib2.urlopen
except:
    import urllib.request
    urlopen = urllib.request.urlopen

def medias():
    '''
        Get media list by GoPro HTTP API
    '''
    url ='http://10.5.5.9:8080/gp/gpMediaList'
    media = json.loads(urlopen(url).read())
    for m in media['media']:
        for n in m['fs']:
            yield '{0}/{1}'.format(m['d'], n)

def getVideo(media):
    '''
        Get video by GoPro
    '''
    rospy.loginfo('Get video of {0}'.format(media))
    url = 'http://10.5.5.9:8080/videos/DCIM/{0}'.format(media)
    return urlopen(url).read()

def getThumb(media):
    '''
        Get video thumbnail by GoPro
    '''
    rospy.loginfo('Get thumbnail of {0}'.format(media))
    url = 'http://10.5.5.9:8080/gp/gpMediaMetadata?p={0}'.format(media) 
    return urlopen(url).read()

def recording(enable):
    rospy.loginfo('Set video enable {0}'.format(enable))
    camera = GoProHero(password='password')
    camera.command('record', 'on' if enable else 'off')

def ipfsPublish(data):
    '''
        Publish bytes by IPFS client
    '''
    rospy.loginfo('IPFS publish data length {0}'.format(len(data)))
    return ipfsapi.connect('127.0.0.1', 5001).add_bytes(data)

if __name__ == '__main__':
    rospy.init_node('drone_recorder_gopro')

    thumbnail = rospy.Publisher('camera/thumbnail', String)
    video = rospy.Publisher('camera/video', String)
    
    def publish_media():
        m = medias()[-1]
        thumbnail.publish(ipfsPublish(getThumb(m)))
        video.publish(ipfsPublish(getVideo(m)))

    def handle_record(msg):
        if msg.data:
            # Start recording the video
            try:
                recording(True)
                return SetBoolResponse(True, '')
            except:
                return SetBoolResponse(False, 'Unable to start recording')
        else:
            # Stop recording and publish thumbnail & video files
            try:
                recording(False)
                thread = Thread(target=publish_media)
                thread.start()
                return SetBoolResponse(True)
            except:
                return SetBoolResponse(False, 'Unable to stop recording')

    rospy.Service('camera/record', SetBool, handle_record)
    rospy.spin()
