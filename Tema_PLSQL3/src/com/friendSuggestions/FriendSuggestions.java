package com.friendSuggestions;

import java.sql.SQLException;
import java.util.*;

public class FriendSuggestions {
    public static void main(String[] args) throws SQLException {
        System.out.print("Student ID: ");
        Scanner scanner = new Scanner(System.in);
        int studentID = scanner.nextInt();
        System.out.print("Number of common friends required: ");
        int numberOfCommonFriendsRequired = scanner.nextInt();
        System.out.print("Maximum number of suggestions: ");
        int maximumNumberOfSuggestions = scanner.nextInt();

        List<FriendSuggestion> friendSuggestions = FriendSuggestion.get(studentID, numberOfCommonFriendsRequired);
        int numberOfSuggestions = maximumNumberOfSuggestions;
        System.out.println("{\n\t\"FriendSuggestions\": [");
        for (int friendSuggestionIterator = 0; friendSuggestionIterator < friendSuggestions.size(); ++friendSuggestionIterator)
            if (numberOfSuggestions > 0) {
                --numberOfSuggestions;

                System.out.print(friendSuggestions.get(friendSuggestionIterator));
                if (friendSuggestionIterator < friendSuggestions.size() - 1)
                    System.out.print(",");
                System.out.println();
            }
        System.out.println("\t]\n}");
    }
}