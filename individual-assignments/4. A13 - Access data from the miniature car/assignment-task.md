# Your assignment:

You have now the ingredients at hand to modify the image data in this example application. In this part of the example (cf. https://github.com/chalmers-revere/working-with-rec-files/blob/master/cpp-opencv/src/template-opencv.cpp#L82-L84Links to an external site.), you have an OpenCV image data structure at hand.

You need to show the following text as overlay on the image from your application; the text must include the following information:

1. for every frame that your microservice is invoked from h264decoder, you need to overlay the current date + time including seconds in UTC format (cf. https://www.utctime.netLinks to an external site.); example: March 23, 2023 at 09:39:12am Stockholm time would be   2023-03-21T08:39:12Z; i.e., the date and time will change throughout the video feed

2. for every frame that your microservice is invoked from h264decoder, you need to overlay the sample time point of the frame

3. for every frame that your microservice is invoked from h264decoder, you need to overlay your first and last name