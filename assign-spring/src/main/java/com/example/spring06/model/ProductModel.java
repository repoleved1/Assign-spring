package com.example.spring06.model;

import com.example.spring06.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;

public interface ProductModel extends PagingAndSortingRepository<Product, Integer> {
    Page<Product> findProductByStatus(int status, Pageable pageable);

    @Query(value = "SELECT product FROM Product product WHERE product.name LIKE :name% AND product.status = :status")
    Page<Product> findByNameAndStatus(String name, int status, Pageable pageable);
}
