import 'package:aiso/NavBar/widgets/markdown_viewer.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  final String privacyText = """
# **GEO MAX - PRIVACY POLICY**

This Privacy Policy sets out our commitment to protecting the privacy of personal information provided to us, or otherwise collected by us, offline or online, including through our Website www.geomax.digital. In this Privacy Policy we, us or our means Real Estate Ai (ABN:  46 685 295 283). 

## Personal information
The types of personal information we may collect about you include: 
* Your name;
* your contact details, including email address, mailing address, street address and/or telephone number; 
* your preferences and/or opinions;
* information you provide to us through customer surveys;
* details of products and services we have provided to you and/or that you have enquired about, and our response to you;
* your browser session and geo-location data, device and network information, statistics on page views and sessions, acquisition sources, search queries and/or browsing behaviour;
* information about your access and use of our Website, including through the use of Internet cookies, your communications with our Website, the type of browser you are using, the type of operating system you are using and the domain name of your Internet service provider;
* additional personal information that you provide to us, directly or indirectly, through your use of our Site, associated applications, associated social media platforms and/or accounts from which you permit us to collect information; and
* any other personal information requested by us and/or provided by you or a third party.]

We may collect these types of personal information directly from you or from third parties.

## Collection and use of personal information
We may collect, hold, use and disclose personal information for the following purposes: 
* to enable you to access and use our Website, and associated applications and associated social media platforms;
* to contact and communicate with you;
* for internal record keeping and administrative purposes;
* for analytics, market research and business development, including to operate and improve our Site, associated applications and associated social media platforms;
* to run competitions and/or offer additional benefits to you; 
* for advertising and marketing, including to send you promotional information about our products and services and information about third parties that we consider may be of interest to you;
* to comply with our legal obligations and resolve any disputes that we may have; and

## Disclosure of personal information to third parties
We may disclose personal information to: 
* [third party service providers for the purpose of enabling them to provide their services, including (without limitation) IT service providers, data storage, webhosting and server providers, debt collectors, maintenance or problem-solving providers, marketing or advertising providers, professional advisors and payment systems operators;
* our employees, contractors and/or related entities;
* our existing or potential agents or business partners;
* sponsors or promoters of any competition we run;
* anyone to whom our business or assets (or any part of them) are, or may (in good faith) be, transferred;
* courts, tribunals and regulatory authorities, in the event you fail to pay for goods or services we have provided to you;
* courts, tribunals, regulatory authorities and law enforcement officers, as required by law, in connection with any actual or prospective legal proceedings, or in order to establish, exercise or defend our legal rights;
* third parties, including agents or sub-contractors, who assist us in providing information, products, services or direct marketing to you. This may include parties located, or that store data, outside of Australia; and
* third parties to collect and process data, such as [Google Analytics or other relevant businesses]. This may include parties that store data outside of Australia

## Your rights and controlling your personal information
* **Choice and consent**: Please read this Privacy Policy carefully. By providing personal information to us, you understand we will collect, hold, use and disclose your personal information in accordance with this Privacy Policy. You do not have to provide personal information to us, however, if you do not, it may affect your use of the Website, or any other products and/or services offered on or through it.
* **Information from third parties**: If we receive personal information about you from a third party, we will protect it as set out in this Privacy Policy. If you are a third party providing personal information about somebody else, you represent and warrant that you have such person's consent to provide the personal information to us. 
* **Restrict**: You may choose to restrict the collection or use of your personal information.  If you have previously agreed to us using your personal information for direct marketing purposes, you may change your mind at any time by contacting us using the details below.
* **Access**: You may request details of the personal information that we hold about you.  An administrative fee may be payable for the provision of such information.  In certain circumstances, as set out in the *Privacy Act 1988* (Cth), we may refuse to provide you with personal information that we hold about you. 
* **Correction**: If you believe that any information we hold about you is inaccurate, out of date, incomplete, irrelevant or misleading, please contact us using the details below. We will take reasonable steps to correct any information found to be inaccurate, incomplete, misleading or out of date.
* **Complaints**: If you believe that we have breached the Australian Privacy Principles and wish to make a complaint, please contact us using the details below and provide us with full details of the alleged breach. We will promptly investigate your complaint and respond to you, in writing, setting out the outcome of our investigation and the steps we will take to deal with your complaint.
* **Unsubscribe**: To unsubscribe from our e-mail database or opt-out of communications (including marketing communications), please contact us using the details below or opt-out using the opt-out facilities provided in the communication.

## Storage and security
We are committed to ensuring that the personal information we collect is secure. In order to prevent unauthorised access or disclosure, we have put in place suitable physical, electronic and managerial procedures to safeguard and secure the personal information and protect it from misuse, interference, loss and unauthorised access, modification and disclosure.
We cannot guarantee the security of any information that is transmitted to or by us over the Internet. The transmission and exchange of information is carried out at your own risk. Although we take measures to safeguard against unauthorised disclosures of information, we cannot assure you that the personal information we collect will not be disclosed in a manner that is inconsistent with this Privacy Policy.

## Cookies and web beacons
We may use cookies on our Site from time to time. Cookies are text files placed in your computer's browser to store your preferences. Cookies, by themselves, do not tell us your email address or other personally identifiable information. However, they do allow third parties, such as Google and Facebook, to cause our advertisements to appear on your social media and online media feeds as part of our retargeting campaigns. If and when you choose to provide our Site with personal information, this information may be linked to the data stored in the cookie.
We may use web beacons on our Site from time to time. Web beacons (also known as Clear GIFs) are small pieces of code placed on a web page to monitor the visitor's behaviour and collect data about the visitor's viewing of a web page. For example, web beacons can be used to count the users who visit a web page or to deliver a cookie to the browser of a visitor viewing that page.

## Links to other websites
Our Website may contain links to other websites. We do not have any control over those websites, and we are not responsible for the protection and privacy of any personal information which you provide whilst visiting those websites. Those websites are not governed by this Privacy Policy.

## Amendments
We may, at any time and at our discretion, vary this Privacy Policy by publishing the amended Privacy Policy on our Website. We recommend you check our Site regularly to ensure you are aware of our current Privacy Policy.

**For any questions or notices, please contact us at**:
Real Estate Ai Pty Ltd,  ABN - 46 685 295 283
Email: justin@reai.au
**Last update**: 5/07/2025
""";


  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => MarkdownContent(markdownText: privacyText, deviceType: DeviceScreenType.mobile),
      tablet: (BuildContext context) => MarkdownContent(markdownText: privacyText, deviceType: DeviceScreenType.mobile),
      desktop: (BuildContext context) => MarkdownContent(markdownText: privacyText, deviceType: DeviceScreenType.desktop),
    );
  }
}