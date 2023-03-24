package tukorea.MBTIbackend.dbconnect.repository;

import tukorea.MBTIbackend.dbconnect.entity.DbEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DbEntityRepository extends JpaRepository<DbEntity, String>{

    @Query(value = "select prdno, allergy from mbti_product where prdno = :prdno", nativeQuery=true)
    List<DbEntity> searchParamRepo(@Param("prdno") String prdno);
}
