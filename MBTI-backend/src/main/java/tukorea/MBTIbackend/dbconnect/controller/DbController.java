package tukorea.MBTIbackend.dbconnect.controller;

import tukorea.MBTIbackend.dbconnect.entity.DbEntity;
import tukorea.MBTIbackend.dbconnect.repository.DbEntityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/db")
public class DbController {

    private final DbEntityRepository dbEntityRepository;

    @PersistenceContext
    private EntityManager entityManager;

    @GetMapping("search")
    public String searchAllProduct() {
        return dbEntityRepository.findAll().toString();
    }

    @GetMapping("searchParam")
    public String searchParamProduct(@RequestParam(value = "allergy") String allergy) {
        List resultList = entityManager.createQuery("select prdno from mbti_product where allergy > :allergy")
                .setParameter("allergy", allergy)
                .getResultList();
        return resultList.toString();
    }

    @GetMapping("searchParamRepo")
    public String searchParamRepoProduct(@RequestParam(value = "prdno") String prdno) {
        return dbEntityRepository.searchParamRepo(prdno).toString();
    }

}
