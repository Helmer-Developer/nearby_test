# nearby_test

[![Analyze](https://github.com/Helmer-Developer/nearby_test/actions/workflows/analyze_workflow.yml/badge.svg)](https://github.com/Helmer-Developer/nearby_test/actions/workflows/analyze_workflow.yml)

## Idea
The basic idea is actually relatively simple to describe: Different Android™ devices each establish a communication link with their available neighbors, thus forming the basis for a network that functions independently of any other infrastructure or ISP. The connected devices can then exchange messages on the network beyond the boundaries of their own connection area. For reasons of simplification and the limited possibilities to use Android™ device functions, the "Nearby" API of Google Mobile Services (GMS) is used, which only works on Android™ devices with preinstalled Google Apps. However, this should not be a problem in Europe, since the distribution is close to 100%. It is important to note that the GMS is not open source software like the Android™ Open Source Project (AOSP), but a proprietary product.

## Nearby Connections API
The Nearby Connections API (NCA) is an interface of the GMS and enables Android™ devices to find each other, connect and exchange data in real time. It is possible to establish connections and identify devices with IDs and exchange data packets with little effort. NCA is particularly beneficial for this project because it unifies a number of smartphone connectivity options, making communication more abstract.
Documentation and further information:
https://developers.google.com/nearby
https://developers.google.com/nearby/connections/overview

## Flutter
Flutter is a software development kit from Google for developing cross plaftorm apps, based on a single code base. The NCA is also available for native Android™ development, however, in addition to pre-existing knowledge, Flutter has further advantages, such as Hot Reload. Which can recompile code changes in under a second and run them on the device without the need to restart the app, providing a significant advantage in terms of speed and productivity.
Documentation and further information:
https://flutter.dev/
https://flutter.dev/docs

## Dvelopment so far
The development so far has mainly been about working out the basics of all the different components. The focus was especially on the connection of two or more devices and the simple exchange of data. In addition, there are also the discoveries of various pitfalls and subtleties, for which unpopular Google APIs are well known.

## Next steps
The next steps include several points. The most important will be to develop a unified and decentralized method that creates a map of the network showing a device's own position relative to all others.
Furthermore, a protocol must be developed, which standardizes the communication between the devices and thus enables communication over several "nodes" in a network. This protocol then contains information about the sender, the receiver, the route of a message and information about what type of request it is, e.g. whether it is a simple text communication or whether it is a request to create a map.

