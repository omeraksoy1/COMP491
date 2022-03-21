//
//  BirdList.swift
//  BirdsOfIstanbul
//
//  Created by Omer Faruk Aksoy on 13.03.2022.
//

import Foundation
import SwiftUI

struct Bird: Identifiable {
    
    var id = UUID().uuidString;
    var name: String
    var description: String
    var image: String
    var link: String
    
}

var birds = [
    Bird(name: "Gull", description: "Gulls are typically medium to large birds, usually grey or white, often with black markings on the head or wings. They typically have harsh wailing or squawking calls; stout, longish bills; and webbed feet. Most gulls are ground-nesting carnivores which take live food or scavenge opportunistically, particularly the Larus species. Live food often includes crustaceans, molluscs, fish and small birds. Gulls have unhinging jaws which allow them to consume large prey. Gulls are typically coastal or inland species, rarely venturing far out to sea, except for the kittiwakes.", image: "gull", link:"https://en.wikipedia.org/wiki/Gull"),
    Bird(name: "Dove", description: "Columbidae is a bird family consisting of pigeons and doves. It is the only family in the order Columbiformes. These are stout-bodied birds with short necks and short slender bills that in some species feature fleshy ceres. They primarily feed on seeds, fruits, and plants. The family occurs worldwide, but the greatest variety is in the Indomalayan and Australasian realms.", image: "dove", link: "https://en.wikipedia.org/wiki/Columbidae"),
    Bird(name: "Eurasian Blackbird", description: "The common blackbird (Turdus merula) is a species of true thrush. It is also called the Eurasian blackbird (especially in North America, to distinguish it from the unrelated New World blackbirds),[2] or simply the blackbird where this does not lead to confusion with a similar-looking local species. It breeds in Europe, Asiatic Russia, and North Africa, and has been introduced to Australia and New Zealand. It has a number of subspecies across its large range; a few of the Asian subspecies are sometimes considered to be full species. Depending on latitude, the common blackbird may be resident, partially migratory, or fully migratory.", image: "eurasianBlackbird", link: "https://en.wikipedia.org/wiki/Common_blackbird"),
    Bird(name: "European Robin", description: "The European robin (Erithacus rubecula), known simply as the robin or robin redbreast in Great Britain, is a small insectivorous passerine bird that belongs to the chat subfamily of the Old World flycatcher family. About 12.5–14.0 cm (4.9–5.5 in) in length, the male and female are similar in colouration, with an orange breast and face lined with grey, brown upper-parts and a whitish belly. It is found across Europe, east to Western Siberia and south to North Africa; it is sedentary in most of its range except the far north.", image: "europeanRobin", link: "https://en.wikipedia.org/wiki/European_robin"),
    Bird(name: "European Starling", description: "The common starling or European starling (Sturnus vulgaris), also known simply as the starling in Great Britain and Ireland, is a medium-sized passerine bird in the starling family, Sturnidae. It is about 20 cm (8 in) long and has glossy black plumage with a metallic sheen, which is speckled with white at some times of year. The legs are pink and the bill is black in winter and yellow in summer; young birds have browner plumage than the adults. It is a noisy bird, especially in communal roosts and other gregarious situations, with an unmusical but varied song. Its gift for mimicry has been noted in literature including the Mabinogion and the works of Pliny the Elder and William Shakespeare.", image: "europeanStarling", link: "https://en.wikipedia.org/wiki/Common_starling"),
    Bird(name: "European Goldfinch", description: "The European goldfinch or simply the goldfinch (Carduelis carduelis) is a small passerine bird in the finch family that is native to Europe, North Africa and western and central Asia. It has been introduced to other areas, including Australia, New Zealand and Uruguay. The breeding male has a red face with black markings around the eyes, and a black-and-white head. The back and flanks are buff or chestnut brown. The black wings have a broad yellow bar. The tail is black and the rump is white. Males and females are very similar, but females have a slightly smaller red area on the face.", image: "europeanGoldfinch", link: "https://en.wikipedia.org/wiki/European_goldfinch")
]
