package tukorea.MBTIbackend.dbconnect.controller;

import org.apache.catalina.User;  // 오류나면 얘

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import tukorea.MBTIbackend.dbconnect.entity.DbEntity;
import tukorea.MBTIbackend.dbconnect.repository.DbEntityRepository;
import lombok.RequiredArgsConstructor;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping("/db")
public class DbController {

    @Autowired
    private final DbEntityRepository dbEntityRepository;

    @PersistenceContext
    private EntityManager entityManager;

    @GetMapping("search")
    public String searchAllProduct() {
        return dbEntityRepository.findAll().toString();
    }

    @GetMapping("searchParam")
    public String searchParamProduct(@RequestParam(value = "prdno") String prdno) {
        List resultList = entityManager.createQuery("select allergy from mbti_product where prdno = :prdno")
                .setParameter("prdno", prdno)
                .getResultList();
        return resultList.toString();
    }

    @GetMapping("searchParamRepo")
    public String searchParamRepoProduct(@RequestParam(value = "prdno") String prdno) {
            return dbEntityRepository.searchParamRepo(prdno).toString();
    }

    @PostMapping("/users")
    public User getProductByPrdno(@RequestBody Map<String, Object> payload) {
        String prdno = (String) payload.get("prdno"); // payload에서 prdno 추출

        Optional<DbEntity> dbEntity = dbEntityRepository.findById(prdno);
        return (User) dbEntity.orElse(null);
    }
}
