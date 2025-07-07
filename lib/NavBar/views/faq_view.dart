import 'package:aiso/NavBar/widgets/markdown_viewer.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FAQView extends StatelessWidget {
  const FAQView({super.key});

  final String faqText = """
# **Frequently Asked Questions**

## What is Generative Engine Optimisation (GEO)?
GEO is the practice of improving how your business is understood, ranked, and recommended by AI tools. It's like SEO, but for the AI era — focused on your online presence, content, reviews, and how well your brand is connected across the web.

## What is GEO MAX?
GEO MAX is a platform that helps businesses see how they rank in AI-generated search tools like ChatGPT and Google Gemini. We give you a clear score and action plan to improve your visibility, trust, and lead generation through Generative Engine Optimisation (GEO).

## What do I get in my free report?
Your first GEO MAX ranking report is completely free, and you'll get a personalised score showing how your business is currently ranked in AI tools.
For a small fee we will also provide you with your competitors rankings (up to the top 10) and recommendations on how to improve your rank.  Monthly or yearly plans make each report cheaper and allow you to track your ranking in ChatGPT and Google Gemini over time.  

## Why should I buy a monthly or yearly plan?
Your ranking in ChatGPT and Google Gemini will change over time.  Particularly as businesses begin to understand the benefits of GEO and how they can feed the AI tools so that they are the ones that are recommended.  You will also receive new recommendations each month on how to move or stay in the #1 spot.

## Will people really use AI tools to search for businesses?
Yes absolutely.  GEO is becoming important as millions of potential customers begin to bypass Google, preferring instead to get instant answers from AI tools. 
Statistics on the decline of Google search and the rise of AI tools include:
* 25% projected decline in traditional search by 2026 (Gartner)¹
* 60% of Google searches now end without a click²
* 180M+ monthly users on ChatGPT³

## Should I wait till AI Search is bigger than Google?
No.  Many businesses wish they got their SEO right for Google years ago because their competitors who did are getting a lot more free leads than they are.  
Today, you have a chance to fix that problem.  The businesses that understand how GEO works and begin to promote their business to become more visible to AI tools are the ones that will be recommended.  As more customers turn to AI to ask, “Who should I hire near me?”, businesses that understand how to show up in those answers now will win. 

## Will GEO MAX really help me generate new leads?
For GEO MAX to help you generate business leads you will need to run a good business that has people's trust, and you will need to implement the recommendations to ensure that trust is transferred to the online world.  Just buying the report won't help you win new leads on its own.

## What makes GEO MAX different from traditional SEO tools?
Traditional SEO focuses on keywords and backlinks for Google's search engine. GEO MAX focuses on how AI assistants — like ChatGPT or Gemini — choose which businesses to recommend. It's not about ranking #1 in Google anymore; it's about being the answer AI gives.

## How do you know what AI tools are using to rank businesses?
We've studied emerging research (like the Princeton University study on GEO), reverse-engineered how AI models respond to local business questions and built a framework that reflects how AI tools evaluate trust and visibility online.  

## Does GEO MAX work for all businesses?
Yes. While we began with real estate as a result of our Real Estate Ai business, GEO MAX works across any business type — from accountants and lawyers to personal trainers, photographers, and trades. If people ask AI who they should use in your industry, GEO MAX can help.

## What do you mean by “AI search”?
AI search refers to people using tools like ChatGPT, and Google Gemini, to ask questions like *“Who's the best dentist in Paddington?”* or *“Which real estate agent should I use in South Yarra?”* These tools use different signals than traditional search engines — and that's what GEO helps you optimise for.

## Do I need an ABN to sign up?
No. Anyone can run a report — whether you're a business owner, freelancer, or just curious. 

## Do you have an Affiliate program?
Yes, absolutely.  We run an Affiliate program, and it is a great way to earn a trailing commission income.  GEO is only going to get bigger and by joining early you'll be positioning yourself as a pioneer in this field.  Visit the Affiliate tab on our website to find out more.

## How do you use my data?
We only use publicly available data and your inputs to generate your report. Your information is secure and never sold or shared.

## Who's behind GEO MAX?
GEO MAX is developed by the team at **Real Estate Ai**, founded by Justin Hodgson, Blair Robinson and now joined by GEO MAX co-founder Jesse Taylor.  We're passionate about AI and how it can help improve the world.

""";


  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => MarkdownContent(markdownText: faqText, deviceType: DeviceScreenType.mobile),
      tablet: (BuildContext context) => MarkdownContent(markdownText: faqText, deviceType: DeviceScreenType.mobile),
      desktop: (BuildContext context) => MarkdownContent(markdownText: faqText, deviceType: DeviceScreenType.desktop),
    );
  }
}