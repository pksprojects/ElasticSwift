#if !canImport(ObjectiveC)
    import XCTest

    extension ClusterRequestsTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__ClusterRequestsTests = [
            ("test_01_clusterHealthRequestBuilder_noThrow", test_01_clusterHealthRequestBuilder_noThrow),
            ("test_02_clusterHealthRequestBuilder", test_02_clusterHealthRequestBuilder),
            ("test_03_clusterHealthRequest", test_03_clusterHealthRequest),
            ("test_04_clusterGetSettingsRequestBuilder_noThrow", test_04_clusterGetSettingsRequestBuilder_noThrow),
            ("test_05_clusterGetSettingsRequestBuilder", test_05_clusterGetSettingsRequestBuilder),
            ("test_06_clusterGetSettingsRequest", test_06_clusterGetSettingsRequest),
            ("test_07_clusterGetSettingsRequest_2", test_07_clusterGetSettingsRequest_2),
            ("test_08_clusterUpdateSettingsRequestBuilder_throw", test_08_clusterUpdateSettingsRequestBuilder_throw),
            ("test_09_clusterUpdateSettingsRequestBuilder_noThrow", test_09_clusterUpdateSettingsRequestBuilder_noThrow),
            ("test_10_clusterUpdateSettingsRequestBuilder", test_10_clusterUpdateSettingsRequestBuilder),
            ("test_11_clusterUpdateSettingsRequest_transient", test_11_clusterUpdateSettingsRequest_transient),
            ("test_12_clusterUpdateSettingsRequest_persistent", test_12_clusterUpdateSettingsRequest_persistent),
        ]
    }

    extension CountRequestTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__CountRequestTests = [
            ("test_01_Count_on_empty_index", test_01_Count_on_empty_index),
            ("test_02_Count_type_query", test_02_Count_type_query),
            ("test_03_Count_q", test_03_Count_q),
            ("test_04_equatable", test_04_equatable),
        ]
    }

    extension ElasticSwiftTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__ElasticSwiftTests = [
            ("test_01_Client", test_01_Client),
            ("test_04_Index", test_04_Index),
            ("test_05_IndexNoId", test_05_IndexNoId),
            ("test_06_Get", test_06_Get),
            ("test_07_Delete", test_07_Delete),
            ("test_10_UpdateRequest", test_10_UpdateRequest),
            ("test_11_UpdateRequest", test_11_UpdateRequest),
            ("test_12_UpdateRequest_noop", test_12_UpdateRequest_noop),
            ("test_13_UpdateRequest_noop_2", test_13_UpdateRequest_noop_2),
            ("test_14_UpdateRequest_upsert_script", test_14_UpdateRequest_upsert_script),
            ("test_15_UpdateRequest_scripted_upsert", test_15_UpdateRequest_scripted_upsert),
            ("test_16_UpdateRequest_doc_as_upsert", test_16_UpdateRequest_doc_as_upsert),
            ("test_17_DeleteByQuery", test_17_DeleteByQuery),
            ("test_18_UpdateByQuery", test_18_UpdateByQuery),
            ("test_19_UpdateByQuery_script", test_19_UpdateByQuery_script),
            ("test_20_mget", test_20_mget),
            ("test_21_ReIndex", test_21_ReIndex),
            ("test_22_ReIndexRequestBuilder_throws", test_22_ReIndexRequestBuilder_throws),
            ("test_23_ReIndexRequestBuilder_throws_2", test_23_ReIndexRequestBuilder_throws_2),
            ("test_24_TermVectorsRequest", test_24_TermVectorsRequest),
            ("test_25_TermVectorsRequestBuilder_throws", test_25_TermVectorsRequestBuilder_throws),
            ("test_26_TermVectorsRequestBuilder_throws_2", test_26_TermVectorsRequestBuilder_throws_2),
            ("test_27_TermVectorsRequestBuilder_throws_3", test_27_TermVectorsRequestBuilder_throws_3),
            ("test_28_TermVectorsRequestBuilder_throws_4", test_28_TermVectorsRequestBuilder_throws_4),
            ("test_29_TermVectorsRequestBuilder_throws_5", test_29_TermVectorsRequestBuilder_throws_5),
            ("test_30_TermVectorsRequest_2", test_30_TermVectorsRequest_2),
            ("test_31_TermVectorsRequest_3", test_31_TermVectorsRequest_3),
            ("test_32_MultiTermVectorsRequest", test_32_MultiTermVectorsRequest),
            ("test_33_BulkRequest", test_33_BulkRequest),
            ("testPlay", testPlay),
        ]
    }

    extension ExplainRequestTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__ExplainRequestTests = [
            ("test_01_explain_q", test_01_explain_q),
            ("test_02_explain_query", test_02_explain_query),
            ("test_03_explain_Equatable", test_03_explain_Equatable),
            ("test_04_explainRequestBuilder_fail_index", test_04_explainRequestBuilder_fail_index),
            ("test_05_explainRequestBuilder_fail_type", test_05_explainRequestBuilder_fail_type),
            ("test_06_explainRequestBuilder_fail_id", test_06_explainRequestBuilder_fail_id),
            ("test_07_explainRequestBuilder_fail_query_q", test_07_explainRequestBuilder_fail_query_q),
            ("test_08_explain_query_matched_false", test_08_explain_query_matched_false),
            ("test_09_sourceFilter_test_bool", test_09_sourceFilter_test_bool),
            ("test_10_sourceFilter_test_single_val", test_10_sourceFilter_test_single_val),
            ("test_11_sourceFilter_test_source_fields", test_11_sourceFilter_test_source_fields),
            ("test_12_sourceFilter_test_source_include_exclude", test_12_sourceFilter_test_source_include_exclude),
            ("test_13_sourceFilter_test_source_include_only", test_13_sourceFilter_test_source_include_only),
            ("test_14_sourceFilter_test_source_exlude_only", test_14_sourceFilter_test_source_exlude_only),
        ]
    }

    extension FieldCapabilitiesRequestTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__FieldCapabilitiesRequestTests = [
            ("test_01_field_caps_empty_index", test_01_field_caps_empty_index),
            ("test_02_fieldCapabilitiesRequestBuilder_fail_missing_fields", test_02_fieldCapabilitiesRequestBuilder_fail_missing_fields),
            ("test_03_fieldCapabilitiesRequestBuilder_fail_empty_fields", test_03_fieldCapabilitiesRequestBuilder_fail_empty_fields),
            ("test_04_field_caps_request_equataable", test_04_field_caps_request_equataable),
            ("test_05_field_caps_with_fields", test_05_field_caps_with_fields),
            ("test_06_field_caps_with_fields_no_index", test_06_field_caps_with_fields_no_index),
        ]
    }

    extension IndicesRequestsTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__IndicesRequestsTests = [
            ("test_01_CreateIndex", test_01_CreateIndex),
            ("test_02_GetIndex", test_02_GetIndex),
            ("test_03_IndexExists", test_03_IndexExists),
            ("test_04_index_open_and_close", test_04_index_open_and_close),
            ("test_999_DeleteIndex", test_999_DeleteIndex),
        ]
    }

    extension RankEvalRequestTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__RankEvalRequestTests = [
            ("test_01_rankEvalRequest_precision", test_01_rankEvalRequest_precision),
            ("test_02_rankEvalRequest_mrr", test_02_rankEvalRequest_mrr),
            ("test_03_rankEvalRequest_dcg", test_03_rankEvalRequest_dcg),
            ("test_04_rankEvalRequest_err", test_04_rankEvalRequest_err),
        ]
    }

    extension ResponseTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__ResponseTests = [
            ("test_01_search_response_decode", test_01_search_response_decode),
            ("test_02_search_response_encode", test_02_search_response_encode),
            ("test_03_search_response_decode_inner_hits", test_03_search_response_decode_inner_hits),
            ("test_04_search_response_encode_inner_hits", test_04_search_response_encode_inner_hits),
            ("test_05_field_capabilities_response_decode", test_05_field_capabilities_response_decode),
            ("test_06_field_capabilities_response_encode", test_06_field_capabilities_response_encode),
        ]
    }

    extension SearchRequestTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__SearchRequestTests = [
            ("test_01_Search", test_01_Search),
            ("test_02_Search_Scroll_Request", test_02_Search_Scroll_Request),
            ("test_03_Search_No_Source_Explicit_Search_Type", test_03_Search_No_Source_Explicit_Search_Type),
            ("test_04_Search_track_scores", test_04_Search_track_scores),
            ("test_05_Search_multiple_sorts", test_05_Search_multiple_sorts),
            ("test_06_Search_index_boost", test_06_Search_index_boost),
            ("test_07_Search_preference_version_seqNoPrimaryTerm", test_07_Search_preference_version_seqNoPrimaryTerm),
            ("test_08_Search_script_fields_explain_true", test_08_Search_script_fields_explain_true),
            ("test_09_Search_script_fields_shard_failed", test_09_Search_script_fields_shard_failed),
            ("test_10_Search_stored_fields", test_10_Search_stored_fields),
            ("test_11_Search_stored_fields_empty_array", test_11_Search_stored_fields_empty_array),
            ("test_12_Search_stored_fields_star", test_12_Search_stored_fields_star),
            ("test_13_Search_docvalue_fields", test_13_Search_docvalue_fields),
            ("test_14_Search_post_filter", test_14_Search_post_filter),
            ("test_15_Search_highlight", test_15_Search_highlight),
            ("test_16_Search_rescoring_2", test_16_Search_rescoring_2),
            ("test_16_Search_rescoring", test_16_Search_rescoring),
            ("test_17_Search_field_collapse_2", test_17_Search_field_collapse_2),
            ("test_17_Search_field_collapse", test_17_Search_field_collapse),
            ("test_18_Search_searchAfter", test_18_Search_searchAfter),
            ("test_19_Search_search", test_19_Search_search),
            ("test_20_searchSource", test_20_searchSource),
            ("test_21_SearchTemplateRequetBuilder", test_21_SearchTemplateRequetBuilder),
            ("test_22_SearchTemplateRequetBuilder_2", test_22_SearchTemplateRequetBuilder_2),
            ("test_23_SearchTemplateRequetBuilder_3", test_23_SearchTemplateRequetBuilder_3),
            ("test_24_SearchTemplateRequetBuilder_4", test_24_SearchTemplateRequetBuilder_4),
            ("test_25_SearchTemplateRequet", test_25_SearchTemplateRequet),
            ("test_26_SearchTemplateRequet_2", test_26_SearchTemplateRequet_2),
            ("test_27_SearchTemplateRequet_3", test_27_SearchTemplateRequet_3),
            ("test_28_StoredScriptRequets", test_28_StoredScriptRequets),
            ("test_29_Suggest_search", test_29_Suggest_search),
        ]
    }

    extension SerializationTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__SerializationTests = [
            ("test_01_encode", test_01_encode),
            ("test_02_encode_fail", test_02_encode_fail),
            ("test_03_decode", test_03_decode),
            ("test_04_decode_fail", test_04_decode_fail),
        ]
    }

    extension SuggestionTests {
        // DO NOT MODIFY: This is autogenerated, use:
        //   `swift test --generate-linuxmain`
        // to regenerate.
        static let __allTests__SuggestionTests = [
            ("test_01_termSuggestionBuilder", test_01_termSuggestionBuilder),
            ("test_02_termSuggestionBuilder_missing_field", test_02_termSuggestionBuilder_missing_field),
            ("test_03_termSuggestionBuilder", test_03_termSuggestionBuilder),
            ("test_04_termSuggestion_decode", test_04_termSuggestion_decode),
            ("test_05_termSuggestion_encode", test_05_termSuggestion_encode),
            ("test_06_phraseSuggestion_missing_field", test_06_phraseSuggestion_missing_field),
            ("test_07_phraseSuggestion", test_07_phraseSuggestion),
            ("test_08_phraseSuggestion", test_08_phraseSuggestion),
            ("test_09_phraseSuggestion_decode", test_09_phraseSuggestion_decode),
            ("test_10_phraseSuggestion_encode", test_10_phraseSuggestion_encode),
            ("test_11_completionSuggestion_missing_field", test_11_completionSuggestion_missing_field),
            ("test_12_completionSuggestion", test_12_completionSuggestion),
            ("test_13_completionSuggestion", test_13_completionSuggestion),
            ("test_14_completionSuggestion_decode", test_14_completionSuggestion_decode),
            ("test_15_completionSuggestion_encode", test_15_completionSuggestion_encode),
            ("test_16_completionSuggestion_decode_2", test_16_completionSuggestion_decode_2),
            ("test_17_completionSuggestion_encode_2", test_17_completionSuggestion_encode_2),
        ]
    }

    public func __allTests() -> [XCTestCaseEntry] {
        return [
            testCase(ClusterRequestsTests.__allTests__ClusterRequestsTests),
            testCase(CountRequestTests.__allTests__CountRequestTests),
            testCase(ElasticSwiftTests.__allTests__ElasticSwiftTests),
            testCase(ExplainRequestTests.__allTests__ExplainRequestTests),
            testCase(FieldCapabilitiesRequestTests.__allTests__FieldCapabilitiesRequestTests),
            testCase(IndicesRequestsTests.__allTests__IndicesRequestsTests),
            testCase(RankEvalRequestTests.__allTests__RankEvalRequestTests),
            testCase(ResponseTests.__allTests__ResponseTests),
            testCase(SearchRequestTests.__allTests__SearchRequestTests),
            testCase(SerializationTests.__allTests__SerializationTests),
            testCase(SuggestionTests.__allTests__SuggestionTests),
        ]
    }
#endif
