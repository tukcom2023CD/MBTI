package tukorea.MBTIbackend.dbconnect.controller;

// import org.apache.catalina.User;  // 오류나면 얘

import org.jetbrains.annotations.NotNull;
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
    public DbEntity getProductByPrdno(@RequestBody @NotNull Map<String, Object> payload) {
        String prdno = (String) payload.get("prdno"); // payload에서 prdno 추출

        Optional<DbEntity> dbEntity = dbEntityRepository.findById(prdno);  // prdno에 해당하는 엔티티 객체를 조회

        if (dbEntity.isPresent()) {    // db에 prdno에 해당하는 엔티티 객체가 있으면
            DbEntity entity = dbEntity.get();
            return entity;
            //처리할 로직 -> 객체를 그대로 반환
        } else {    // db에 prdno에 해당하는 엔티티 객체가 존재하지 않으면
            //처리할 로직 -> 크롤링하기
        }
        return (DbEntity) dbEntity.orElse(null);
    }
}
