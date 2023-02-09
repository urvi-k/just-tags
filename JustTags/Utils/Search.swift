//
//  Search.swift
//  JustTags
//
//  Created by Yurii Zadoianchuk on 02/02/2023.
//

import Foundation

extension Set<String> {
    
    internal func asFlattenedSearchComponents() -> Set<String> {
        Set(self.flatMap(\.toFlattenedSearchComponents))
    }
    
}

extension String {
    
    var isSearchComponent: Bool {
        count > 2 || UInt64(self, radix: 16) != nil
    }
    
    var toFlattenedSearchComponents: [String] {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: .punctuationCharacters)
            .components(separatedBy: .whitespacesAndNewlines)
            .map { $0.trimmingCharacters(in: .punctuationCharacters) }
            .map(\.localizedLowercase)
            .filter(\.isSearchComponent)
    }
    
}

struct PrioritySearchComponents {
    internal let primary: Set<String>
    internal let secondary: Set<String>
}

struct PrioritySearchResult<P: PrioritySearchable> {
    let bestMatches: [P]
    let more: [P]
}

protocol PrioritySearchable: Comparable, Hashable {
    
    var searchPair: (hash: Int, comps: PrioritySearchComponents) { get }
    
}

protocol SimpleSearchable: Comparable, Identifiable {
    
    var searchPair: (id: Self.ID, comps: Set<String>) { get }
    
}

protocol NestedSearchable: SimpleSearchable {
    
    var searchPairs: [(id: Self.ID, comps: Set<String>)] { get }
    
    func filterNested(
        using words: Set<String>,
        components: [Self.ID: Set<String>]
    ) -> Self
    
}

protocol SearchComponentsAware {
    
    var searchComponents: Set<String> { get }
    
}

func filterPrioritySearchable<P: PrioritySearchable>(
    initial: [P],
    components: [Int: PrioritySearchComponents],
    words: Set<String>
) -> PrioritySearchResult<P> {
    let grouped = initial.reduce(into: (primary: [P](), secondary: [P]())) { (result, info) in
        guard let term = components[info.hashValue] else { return }
        if words.isPartialMatchSubset(of: term.primary) {
            result.primary.append(info)
        } else if words.isPartialMatchSubset(of: term.secondary) {
            result.secondary.append(info)
        }
    }
    
    return .init(
        bestMatches: grouped.primary.sorted(),
        more: grouped.secondary.sorted()
    )
}

func filterSimpleSearchable<S: SimpleSearchable>(
    initial: [S],
    components: [S.ID: Set<String>],
    words: Set<String>
) -> [S] {
    initial.filter { searchable in
        guard let comps = components[searchable.id] else { return false }
        return words.isPartialMatchSubset(of: comps)
    }
}

func filterNestedSearchable<N: NestedSearchable>(
    initial: [N],
    components: [N.ID: Set<String>],
    words: Set<String>
) -> [N] {
    initial.filter { searchable in
        guard let comps = components[searchable.id] else { return false }
        return words.isPartialMatchSubset(of: comps)
    }.map { searchable in
        searchable.filterNested(using: words, components: components)
    }
}

extension Set<String> {
    func isPartialMatchSubset(of rhs: Self) -> Bool {
        self.allSatisfy { element in
            rhs.contains(where: { rElement in
                rElement.contains(element)
            })
        }
    }
}

extension Array<Set<String>> {
    func foldToSet() -> Set<String> {
        self.reduce(Set<String>()) { (result, element) in
            result.union(element)
        }
    }
}