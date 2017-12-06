---
output: html_document
---

## Data visulization of the US air pollution

***

Welcome to the data visulization application for the US air pollution between 2000 and 2016
Our project will explore the dataset of the US Air Pollution from 2010 to 2016. [The
original data of the US air pollution is collected from the Environmental Protection
Agency, summarized by BrendaSo in Kaggle.](https://data.world/data-society/us-air-pollution-data)


Since there are a few interesting questions around air pollution, our project will heavily focus on
the following four aspects:

* Which air pollutant contributes the most to the air pollution of a state?

* What's the distribution of air pollution across the states in each year?

* How one air polluant correlates with another one?

* How air pollutant changes based on time? (such as what is the change of each air pollutant based on months)

In order to answer these questions, there are two aspects we need to be concerned in this application:

* Which air pollutants do we need for answering the questions?

* How to choose a basic stand for comparing different air pollutant since differnt air pollutants may have
different level of impact even in the same amount?

For the first aspect, we decide to analyze some common-known air pollutants such as Carbon monoxide (CO),
Nitrogen Dioxide (NO2), Sulfur Dioxide (SO2), and Ozone (O3) since most people have good understanding towards these air pollutent and therefore can produce better insights once we visulized these air pollutants
based on our project's proposed questions.

For the second aspect, we decide to incoporate Air Quaility Index (AQI) as the standard to measure the impact of each air pollutants to air quaility. Since it is well-known index for evaluating air pollutants 
in academic research for air pollutation and it is also an techiquene used by our government for reporting
air quaility, it would be better to apply this standard for normalizing the air pollution severeness.

Since we have finished the setting, here are some data visulization tools we think may be useful for answering our questions:

* Firstly, we constructed a Pie Chart showing percentage of AQI of each pollutant in the
state that our users are interested at. This pie chart will clearly shows the general status of each pollutant in each state and will show the internal comparasion between each pollutants at each state. By connecting the real situation of each state, it would give us a better understanding on which air pollutant contributes the most to the air pollution at given state.


* Secondly, we built an interactive geographical map of the united states in a purpose of 
showing the data in a more straightforward way. The user can easily hover on the map to
get the detailed information of each state. Also, it is rather clear that the darker the color
of one state in the map is, the more severe the pollution problem that state has. By
playing with this interactive map, our user would definitely have an overall pollution
information across states in mind.


* Thirdly, a scatter plot is also built in our project, from this scatter plot, our users would be
able to choose two kinds of pollution of interest, and the system will automatically draw a
plot comparing these two pollution elements. This would be rather effective when the
user is concerned about the correlation between two specific pollutants. With those in mind, the scatter plot could give our user good prediction towards different air pollutants and could help them generate better insights on how one air pollutant can affect the others.


* Last but not the least, we have the revealing each pollutant amount in specific years that
the user concerns about. From this bar graph, not only it would give our users a general
idea of the total pollution amount in each month, but also the distribution of each kind of
pollutants in each month can also be cleared shown to the user by comparing the height
of the pollutants in each bar. Since some activities with high level of air pollutant emission are depended 
on months or quarters, this plot can demonstrate good understanding towards paring the activities with the change of months.


Further information will be available at Q&A session.
