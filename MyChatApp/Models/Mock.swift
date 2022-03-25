//
//  Mock.swift
//  MyChatApp
//
//  Created by Юрий Андрианов on 07.03.2022.
//

import Foundation

// Fake models
struct Mock {
    
    static let conversations: [Conversation] = [
        Conversation(name: "Steve Jobs", online: true, messages: mockMessages1),
        Conversation(name: "Adam Johnson", online: true, messages: nil),
        Conversation(name: "Jessica Williams", online: false, messages: nil),
        Conversation(name: "Peter Parker", online: true, messages: mockMessages2),
        Conversation(name: "Bruce Wayne", online: false, messages: mockMessages3),
        Conversation(name: "Tom Cruz", online: true, messages: mockMessages4),
        Conversation(name: "George Bush", online: false, messages: nil),
        Conversation(name: "Ross Geller", online: false, messages: mockMessages5),
        Conversation(name: "Monica Geller", online: true, messages: nil),
        Conversation(name: "Chandler Bing", online: false, messages: mockMessages6),
        Conversation(name: "Joey Tribbiany", online: false, messages: nil),
        Conversation(name: "Phoebe Buffet", online: false, messages: mockMessages7),
        Conversation(name: "Rachel Green", online: false, messages: mockMessages8),
        Conversation(name: "Ted Mosby", online: true, messages: mockMessages9),
        Conversation(name: "Marshal Ericsson", online: true, messages: nil),
        Conversation(name: "Barney Stinson", online: false, messages: mockMessages10),
        Conversation(name: "Robin Scherbatsky", online: false, messages: mockMessages11),
        Conversation(name: "Walter White", online: true, messages: mockMessages12),
        Conversation(name: "Jesse Pinkman", online: false, messages: nil),
        Conversation(name: "Saul Goodman", online: true, messages: mockMessages13),
        Conversation(name: "Mike Ehrmantraut", online: false, messages: nil),
        Conversation(name: "Hank Schrader", online: true, messages: mockMessages14)
    ]
    
    static let mockMessages1: [Message] = [
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "We want to get to know you! Please reply with the type of messages you’d like to receive from us.",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Julie, we haven’t heard from you in a while. We wanted to check in and see if there was anything we could help you with?",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "You’re one step closer to 2 tickets. We’ll send you updates on other competitions and first dibs on early ticket releases. Enjoy!",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Reply STOP to unsubscribe or HELP for help. 4 msgs per month, Msg&Data rates may apply",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Thanks for joining our text club! We’ll share our latest deals and discounts right here, exclusively with you.",
                isIncoming: false,
                unread: false)
    ]
    
    static let mockMessages2: [Message] = [
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Attention to our VIP’s! Show this text to your server this week for a complimentary basket of fries for your table",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Congrats on your tenth purchase! Enjoy a free cup of coffee and one pastry item on us by showing the cashier this text message!",
                isIncoming: true,
                unread: false)
    ]
    
    static let mockMessages3: [Message] = [
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Hi Barb, I wanted to reach out and personally thank you for signing up to our text club. I look forward to chatting more soon.",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Tina, welcome to the Arctic Club texting list. Here, we’ll share lineups, specials, and events with you each month.",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Josh, thank you for sharing your number with the Spectrum team. Please reply with Yes if this is the best way to reach you!",
                isIncoming: false,
                unread: false)
    ]
    
    static let mockMessages4: [Message] = [
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "We want to get to know you! Please reply with the type of messages you’d like to receive from us.",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Julie, we haven’t heard from you in a while. We wanted to check in and see if there was anything we could help you with?",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "You’re one step closer to 2 tickets. We’ll send you updates on other competitions and first dibs on early ticket releases. Enjoy!",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Reply STOP to unsubscribe or HELP for help. 4 msgs per month, Msg&Data rates may apply",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Thanks for joining our text club! We’ll share our latest deals and discounts right here, exclusively with you.",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Hi Barb, I wanted to reach out and personally thank you for signing up to our text club. I look forward to chatting more soon.",
                isIncoming: false,
                unread: false)
    ]
    
    static let mockMessages5: [Message] = [
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "We want to get to know you! Please reply with the type of messages you’d like to receive from us.",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Julie, we haven’t heard from you in a while. We wanted to check in and see if there was anything we could help you with?",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Eleanor, you have an appointment scheduled with Dr. Jin at 10:30 tomorrow morning.
                Please be sure to arrive at 1010 A Street in Boston 15 minutes early!
                """,
                isIncoming: true,
                unread: true),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Holiday weekend cancelation alert!
                Some rooms opened and we’re giving away two FREE nights in the lodge, lift tickets included.
                Text “PoconosMDW” to enter!
                """,
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Hey there!
                As a special thank you for joining the Run Family, enter code RUN20 at checkout for 20% off your next order!
                http://text.tl/mJPLPM
                """,
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "You’re one step closer to 2 tickets. We’ll send you updates on other competitions and first dibs on early ticket releases. Enjoy!",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Reply STOP to unsubscribe or HELP for help. 4 msgs per month, Msg&Data rates may apply",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Hey Annie, it’s Russ from Wag!
                I wanted to welcome you to our text program. Our newest way to reach customers.
                We look forward to chatting with you more soon!
                """,
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Thanks for joining our text club! We’ll share our latest deals and discounts right here, exclusively with you.",
                isIncoming: false,
                unread: false)
    ]
    
    static let mockMessages6: [Message] = [
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Cornwall staff, lock your doors and engage in code red protocol.
                The office is on lockdown. Shelter in a safe place and wait for an all clear text to arrive.
                """,
                isIncoming: false,
                unread: true),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Sam, your rent payment for Jan 19 has been received.
                $1,300 will be drafted from your Wells Fargo Account ******0000 within 24-48 business hours.
                Thank you!
                """,
                isIncoming: true,
                unread: true),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Attention to our VIP’s! Show this text to your server this week for a complimentary basket of fries for your table",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Congrats on your tenth purchase! Enjoy a free cup of coffee and one pastry item on us by showing the cashier this text message!",
                isIncoming: true,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Tammy, thanks for choosing Carl’s Car Wash for your express polish.
                We would love to hear your thoughts on the service.
                Feel free to text back with any feedback. Safe driving!
                """,
                isIncoming: true,
                unread: true),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Hey Jessica!
                I wanted to let you know a property on Boylston street opened up that I think you’d be interested in.
                Would you like me to text you the info for the open house?
                """,
                isIncoming: true,
                unread: false)
    ]
    
    static let mockMessages7: [Message] = [
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Hi Barb, I wanted to reach out and personally thank you for signing up to our text club. I look forward to chatting more soon.",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Tina, welcome to the Arctic Club texting list. Here, we’ll share lineups, specials, and events with you each month.",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Hi Kryss!
                I wanted to introduce myself, I’m Pete.
                Just dropping in to let you know I’m a real person, not a robot, and I’m here to answer any of your questions 😄
                """,
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Josh, thank you for sharing your number with the Spectrum team. Please reply with Yes if this is the best way to reach you!",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Laura, you can text us at any time, but we wanted to share a link to our help center in case you need assistance outside business hours!
                http://txt.tl/mJPLPM
                """,
                isIncoming: false,
                unread: false)
    ]
    
    static let mockMessages8: [Message] = [
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Hi Kelly, I wanted to introduce myself.
                My name is Bea and I’ll be your dedicated sales rep.
                Don’t hesitate to reach out if you need anything. That’s what I’m here for :-}
                """,
                isIncoming: true,
                unread: true),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Josh, thank you for sharing your number with the Spectrum team. Please reply with Yes if this is the best way to reach you!",
                isIncoming: false,
                unread: false)
    ]
    
    static let mockMessages9: [Message] = [
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Cornwall staff, lock your doors and engage in code red protocol.
                The office is on lockdown.
                Shelter in a safe place and wait for an all clear text to arrive.
                """,
                isIncoming: false,
                unread: true),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Sam, your rent payment for Jan 19 has been received.
                $1,300 will be drafted from your Wells Fargo Account ******0000 within 24-48 business hours.
                Thank you!
                """,
                isIncoming: true,
                unread: true),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Hey Jessica! I wanted to let you know a property on Boylston street opened up that I think you’d be interested in.
                Would you like me to text you the info for the open house?
                """,
                isIncoming: true,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Holiday weekend cancelation alert!
                Some rooms opened and we’re giving away two FREE nights in the lodge, lift tickets included.
                Text “PoconosMDW” to enter!
                """,
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Hey there!
                As a special thank you for joining the Run Family, enter code RUN20 at checkout for 20% off your next order!
                http://text.tl/mJPLPM
                """,
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "You’re one step closer to 2 tickets. We’ll send you updates on other competitions and first dibs on early ticket releases. Enjoy!",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Reply STOP to unsubscribe or HELP for help. 4 msgs per month, Msg&Data rates may apply",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Hey Annie, it’s Russ from Wag!
                I wanted to welcome you to our text program. Our newest way to reach customers.
                We look forward to chatting with you more soon!
                """,
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Thanks for joining our text club! We’ll share our latest deals and discounts right here, exclusively with you.",
                isIncoming: false,
                unread: false)
    ]
    
    static let mockMessages10: [Message] = [
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Attention to our VIP’s! Show this text to your server this week for a complimentary basket of fries for your table",
                isIncoming: false,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Congrats on your tenth purchase! Enjoy a free cup of coffee and one pastry item on us by showing the cashier this text message!",
                isIncoming: true,
                unread: false),
        
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Tammy, thanks for choosing Carl’s Car Wash for your express polish.
                We would love to hear your thoughts on the service.
                Feel free to text back with any feedback. Safe driving!
                """,
                isIncoming: true,
                unread: true)
    ]
    
    static let mockMessages11: [Message] = [
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Tina, welcome to the Arctic Club texting list. Here, we’ll share lineups, specials, and events with you each month.",
                isIncoming: false,
                unread: false),
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Hi Kryss!
                I wanted to introduce myself, I’m Pete.
                Just dropping in to let you know I’m a real person, not a robot, and I’m here to answer any of your questions 😄
                """,
                isIncoming: false,
                unread: false),
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Josh, thank you for sharing your number with the Spectrum team. Please reply with Yes if this is the best way to reach you!",
                isIncoming: false,
                unread: false)
    ]
    
    static let mockMessages12: [Message] = [
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "We want to get to know you! Please reply with the type of messages you’d like to receive from us.",
                isIncoming: false,
                unread: false),
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Julie, we haven’t heard from you in a while. We wanted to check in and see if there was anything we could help you with?",
                isIncoming: false,
                unread: false),
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Eleanor, you have an appointment scheduled with Dr. Jin at 10:30 tomorrow morning.
                Please be sure to arrive at 1010 A Street in Boston 15 minutes early!
                """,
                isIncoming: true,
                unread: true),
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Hi Barb, I wanted to reach out and personally thank you for signing up to our text club. I look forward to chatting more soon.",
                isIncoming: false,
                unread: false),
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Tina, welcome to the Arctic Club texting list. Here, we’ll share lineups, specials, and events with you each month.",
                isIncoming: false,
                unread: false),
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Hi Kryss!
                I wanted to introduce myself, I’m Pete.
                Just dropping in to let you know I’m a real person, not a robot, and I’m here to answer any of your questions 😄
                """,
                isIncoming: false,
                unread: false)
    ]
    
    static let mockMessages13: [Message] = [
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Attention to our VIP’s! Show this text to your server this week for a complimentary basket of fries for your table",
                isIncoming: false,
                unread: false),
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "Congrats on your tenth purchase! Enjoy a free cup of coffee and one pastry item on us by showing the cashier this text message!",
                isIncoming: true,
                unread: false),
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: """
                Tammy, thanks for choosing Carl’s Car Wash for your express polish.
                We would love to hear your thoughts on the service.
                Feel free to text back with any feedback. Safe driving!
                """,
                isIncoming: true,
                unread: true)
    ]
    
    static let mockMessages14: [Message] = [
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "😀",
                isIncoming: true,
                unread: false),
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "🐹",
                isIncoming: false,
                unread: false),
        Message(date: Date().addingTimeInterval(TimeInterval(Double.random(in: -1000000 ... -1))),
                text: "👍",
                isIncoming: true,
                unread: false)
    ]
    
}
