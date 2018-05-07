# IntersectionSolver
iOS app to create and solve the order of vehicles through an intersection


## Demo
![Application demo gif](https://thumbs.gfycat.com/WaterySlushyAnnashummingbird-size_restricted.gif)


## Details
The app uses a weighted directed graph to represent the intersection. 
When two endpoints of a road are selected, the road is drawn (see demo above)
and an edge with weight 1 is added to the graph. Adding stop/yield signs to
a road modifies its belonging edge's weight to 5, which effectively 
gives the other vehicles the right of way. 




### Note
This was essentially hacked together in a weekend. The code and UI could be a lot better.
