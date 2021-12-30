---
title: "The Cold Start Problem by Andrew Chen"
date: "2021-12-29"
description: "Network effect describes what happens when products get more valuable as more people use them though most new networks fail as people won’t stick around if they don’t find who or what they want."
tags: ["startup", "traction"]
categories: ["reading-notes"]
---

## What is network effect?

Network effect describes what happens when products get more valuable as more people use them. If your friends, family, coworkers, celebrities you follow aren’t using the same apps you’re using, you will leave. The network is pretty much useless.

Network effects are embedded into many of the successful products around us in different variations. eBay, Uber, Airbnb are networks of buyers and sellers. Dropbox, Slack, Google Suite are networks of your teammates and coworkers.

Launching a new product today is incredibly challenging because 1) tech giants are using the network effects to keep people stay 2) bootstrapping a new network is hard 3) there’s a millions of apps out there as software has been easier to build 4) competing over people’s attention is a zero-sum game 5) people attention is getting shorter.

Network effects are one of the protective barriers where competition is intense. Instagram might be able to copy Snapchat’s Stories but it’s hard to have their users switch over. It’s easy to copy the product but hard to capture the network.

To understand network effects, while Metcalfe’s Law is clever for its time, it hasn’t aged well because it leaves out important phases of building a network: what you do when one one uses your product, the quality of user engagement, active users vs people who have signed up and so on. Introducing 5 stages of Cold Start Theory:
- The Cold Start Problem: most new networks fail as people won’t stick around if they don’t find who or what they want.
- Tipping Point: to win the market, it’s important to build many more networks after the first one.
- Escape Velocity: network effects hit, it’s time to strengthen them.
- Hitting the Ceiling: strategy when growth stalls.
- The Moat: how use network effects to fend off competitors.

This post only focuses on the Cold Start Problem.

## The Cold Start Problem

### Slack

Tiny Speck first product’s Glitch was a failure. The team raised $17 millions from top investors, hired an all-star team, had an exciting launch, shipped a beta version after 2 years. The problem was that people didn’t stick around as 97% people who signed up left after 5 minutes. Since Glitch was a multiplayer game, it would only fun when a lot of people were playing. Years later, the company launched Slack and the rest was history.

How did they pull that off? In 2009, the team was distributed across SF and Vancouver. Remote work was nascent so the tools supporting this kind of work were pretty much non-existent. So the team built a chat tool on top of IRC to help communicating with each other. When it was clear that Glitch wasn’t working, the team decided to redesign their chat tool so anyone could use it. It was rebuilt with a new back-end, and solving all issues IRC had such as searchable conversations, hosting photos, automatic back-up, and so on. Fun fact, Slack was picked to mean “Searchable Log of All Conversation and Knowledge”.

Next, they started to reach out to their fiends at other companies to convince them why it was cool. They personally handle all the feedback on social media and customer support ticket. Each of these beta customers formed an atomic network, self-sustaining group of users. They found out that the minimum number of people to be defined as a team was 3. The team learned more as the product was tied with larger networks, how it was used and spread, pieced together a network of network at larger companies.

### Atomic network

Small networks naturally dies because when people show up to a product and none of their friends or coworkers are using it, they will leave. For Slack, it works with 2 people but it takes 3 to make it really work. How they engage with each other also matters. Any team that has exchanged 2000 messages, most will stick around and keep using the product. For Facebook, it’s “10 friends in 7 days”. For Airbnb, 300 listings with 100 reviewed listings is the magic number to see growth in a market. For Uber, keeping ETAs down is the key metric.

In order to solve the Cold Start Problem, a network must have enough density and interconnectedness. It starts by understanding how to add a small group of the right people, at the same time, using the product in the right way. For Slack, if the network is small, you are not able to message who you want or get your reply quickly, your coworker will just wonder why you didn’t send an email. On the other hand, if you add more people but random people and they don’t interact with each other, it won’t work.

A network must start small, in a single city, college campus, small beta tests at individual companies. The goal is to create a stable, engaged network that can self-sustain, an atomic network.

### Credit card

Bank of America invented the credit card and picked Fresno, California to test because the town was small enough, 250k population, and 45% of Fresno’s families did some businesses with them. They started by mailing 60k cards. There was no application process. The card was ready to use with $300-500 credits. It was brilliant because cardholders existed on day 1. They would then sign up all merchants who didn’t have proprietary credit card programs and ended up with 300. Within 3 months, Bank of America expanded its customer based to other towns and after thirteen months, 2 millions cards were issued and 20K merchants were onboarded.

While Slack only requires 3 people to build an atomic network, Bank of America’s credit card need at least an entire city.

### Growth hacks

Embedded within the strategy for forming the initial atomic networks is a series of growth hacks. For Slack, it was their buzz within the early-adopter startup community, and their invite-only launch. For Dropbox, it was their demo video on Hacker News that made people wanted to try out. “Uber Ice Cream” famously let people order ice cream on demand.

The first step to launching an atomic network is to form a hypothesis about what it might look like. Focus on building a small and specific one,  something tiny, on the order of hundred of people, at a specific moment in time. In the early days for Uber, it wasn’t SF or NYC but “5pm at the Caltrain station at 5th and King St.” The team had an internal tool to direct drivers to popular locations.

### The Hard Side

Even at the start of an atomic network, there is a minority of users that do more work and contribute more to your network, but are much harder to acquire and retain. For example, there are 100 million riders on Uber but a few million riders. The best Uber drivers work many times more hours than the average driver. For Youtube, there are 2 billion active users but a few million uploaded videos. 20% of top creators end up with the majority of engagement: millions of followers, millions of views. For Valve’s Steam, the best developer build a content that is downloaded a million time, require millions of dollar to create. At the end of the day, those put the most efforts and produce the most values. This is the hard side of a network, comparing to the easy side which are general consumers.

1/10/100 says that 1% of users might start a group, 10% might participate actively, 100% benefit from the above groups.

A successful product should carter to those users from day 1 by focusing on understanding users’ motivation:
- Who is the hard side?
- How will they use the product?
- What is the unique value proposition to the hard side?
- How do they first hear about the app, in what context?
- As the network grows, why will they come back and become more engaged?
- What make them stick?

### Tinder

Online dating was invented in the early 90s where Match.com and JDate were successful pioneers. Since these websites were essentially a large databases of profiles, the UX wasn’t great for everyone. Years later, eHarmony and OKCupid introduced quizzes and matching algorithms that made the whole UX a bit better. It wasn’t until 2012 that Tinder innovate even further. They thought dating felt like work so they made it fun. 1) One could sign up without filling a bunch of form. 2) One could swipe back and forth and all that took was a couple of seconds. 3) They introduced context and trust by connecting users’ Facebook to show mutual friends, only matching with people who are nearby, building a internal chat so people don’t have to give out phone numbers, adding the ability to unmatch without worrying about getting harassed. Importantly, they focused on fixing the hard side where the matching algorithm need to find equally attractive matches and help users decide between princes and frogs.

The hard side for marketplaces is usually the supply side. For eBay, you start with sellers of collectibles. For Airbnb, you start with people with a few extra rooms. For GitHub, you start by bringing some prominent open-source projects and key developers. For Uber, you let anyone sign up to be a driver (instead of just black car and limo services initially).

The best way to acquire these insights is to look at hobbies and side hustles. For photo-sharing and messaging app, they stem from countless amateur and videographers who like to record travel and special occasions. Similarly, there are developers hind the open-source movement who have built Linux, WordPress, MySQL.

What people are doing on nights and weekends represents all the underutilized time and energy. Rideshare networks depend on the underutilization of cars, which sit idle most of the time. Airbnb depend on the underutilization of guest bedrooms and second homes. Craigslist and eBay depend on the underutilization of old items that new owner might value more. The trick is to look closer at the underserved.

### Zoom

Eric Yuan found Zoom in 2011 and ten years later it was worth $90 billion. However, in the beginning, people didn’t get the idea of Zoom because 1) there were already big players like WebEx, GoToMeeting, and Skype 2) it didn’t have more features and just seemed too simple. The thing was, Zoom’s value proposition was to enable frictionless meeting where attendees could join with a simple click of a link rather than entering meeting codes and so on. Besides, there was an ecosystem of vendors and consultants working with Zoom to build a stronger network. Its freemium business model also helped it grow virally.

Zoom is considered a networked product where they facilitate experiences that users have with each other. In contrast, traditional products focus on how user interact with the product itself. Zoom grow by adding more users, which create network effects, instead of building better features and supporting more use cases. All in all, Zoom has the 2 factors that make it an ideal product. 1) The product itself is as simple as possible, easily understandable by anyone. 2) It brings a rich network of users that is hard to copy by competitors.

### Magic moment

It becomes obvious when a product has solved the Cold Start Problem. You open a collaboration app and all the relevant tasks are there. You open a social app, engaging content are there. You have notifications because others send you messages. If your product have reached this state, congratulation! You've made through the first step.

**References:**
- <https://www.goodreads.com/book/show/55338968-the-cold-start-problem>
