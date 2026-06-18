package com.vote.repository;

import com.vote.entity.VoteItem;
import java.util.List;

public interface VoteRepository {
  List<VoteItem> findAll();
  VoteItem findById(Integer id);
  int insert(String name);
  int update(Integer id, String name);
  int delete(Integer id);
  void castVotes(String voter, List<Integer> itemIds);
}
